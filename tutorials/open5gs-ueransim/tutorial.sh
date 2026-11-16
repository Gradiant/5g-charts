#!/usr/bin/env bash
# These are the commands used by both readers and CI. Run only in the disposable Kind cluster.
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)
DIR="$ROOT/tutorials/open5gs-ueransim"
STATE=${TUTORIAL_STATE_DIR:-"$ROOT/reports/tutorial-ueransim"}
SOURCE=${TUTORIAL_SOURCE:-published}
NS=open5gs-tutorial
[[ "$SOURCE" == published || "$SOURCE" == candidate ]] || { echo "Invalid TUTORIAL_SOURCE" >&2; exit 2; }
[[ "$(kubectl config current-context)" == kind-5g-tutorial ]] || {
    echo "Use the dedicated kind-5g-tutorial context and kubeconfig; refusing another cluster." >&2; exit 2;
}
mkdir -p "$STATE"

mark() {
    python3 - "$STATE/checks.json" "$1" <<'PY'
import json,sys
from pathlib import Path
p=Path(sys.argv[1]); checks=json.loads(p.read_text()); checks[sys.argv[2]]=True
p.write_text(json.dumps(checks,indent=2)+'\n')
PY
}

case "${1:-}" in
install)
    printf '{}\n' > "$STATE/checks.json"
    printf '{}\n' > "$STATE/validation.json"
    mkdir -p "$STATE/packages"
    for chart in open5gs ueransim-gnb; do
        version=$(python3 "$ROOT/scripts/tutorials/ueransim.py" version --chart "$chart" --source "$SOURCE")
        if [[ "$SOURCE" == candidate ]]; then
            helm repo add bitnami https://charts.bitnami.com/bitnami
            helm dependency update "$ROOT/charts/$chart" --skip-refresh
            helm package "$ROOT/charts/$chart" --destination "$STATE/packages"
        else
            helm pull "oci://registry-1.docker.io/gradiantcharts/$chart" --version "$version" \
                --destination "$STATE/packages" 2>&1 | tee "$STATE/pull-$chart.log"
        fi
        values="$DIR/open5gs-values.yaml"
        release=open5gs
        if [[ "$chart" == ueransim-gnb ]]; then values="$DIR/ueransim-values.yaml"; release=ueransim-gnb; fi
        helm upgrade --install "$release" "$STATE/packages/$chart-$version.tgz" \
            --namespace "$NS" --create-namespace --values "$values" --wait --timeout 10m
    done
    ;;
verify)
    # Wait for real PDU interfaces; Deployment Ready alone does not establish connectivity.
    connected=false
    for attempt in $(seq 1 60); do
        if kubectl -n "$NS" exec deployment/ueransim-gnb-ues -- \
            sh -c 'ip -4 -o addr show uesimtun0 | grep " inet " && ip -4 -o addr show uesimtun1 | grep " inet "' > "$STATE/tunnels.log" 2>&1; then
            connected=true; break
        fi
        sleep 3
    done
    [[ "$connected" == true ]] || { cat "$STATE/tunnels.log"; exit 1; }
    kubectl -n "$NS" logs deployment/ueransim-gnb-ues --all-containers > "$STATE/ues.log"
    # The two IMSIs must each register and establish a session. The image prefixes each UE's log.
    for index in 0 1; do
        ue="99970000000000$((index + 1))"
        grep -E "\[$ue\|nas\].*Registration is successful" "$STATE/ues.log"
        mark "registration_$index"
        grep -E "\[$ue\|nas\].*PDU Session establishment is successful" "$STATE/ues.log"
        mark "session_$index"
        kubectl -n "$NS" exec deployment/ueransim-gnb-ues -- \
            ping -I "uesimtun$index" -c 5 -W 3 8.8.8.8 | tee "$STATE/traffic-$index.log"
        grep -E '(^|[, ])0% packet loss' "$STATE/traffic-$index.log"
        mark "traffic_$index"
    done
    kubectl -n "$NS" exec statefulset/open5gs-mongodb -- mongosh --quiet --eval \
        'if (db.getSiblingDB("open5gs").subscribers.countDocuments({imsi: {$in: ["999700000000001", "999700000000002"]}}) !== 2) quit(1)'
    mark subscribers
    kubectl -n "$NS" exec deployment/open5gs-populate -- open5gs-dbctl add_ue_with_slice \
        999700000000003 465B5CE8B199B49FAA5F0A2EE238A6BC E8ED289DEBA952E4283B54E88E6183CA internet 1 111111
    kubectl -n "$NS" exec statefulset/open5gs-mongodb -- mongosh --quiet --eval \
        'if (db.getSiblingDB("open5gs").subscribers.countDocuments({imsi: "999700000000003"}) !== 1) quit(1)'
    mark additional_subscriber
    kubectl -n "$NS" port-forward service/open5gs-webui 19999:9999 > "$STATE/webui-forward.log" 2>&1 &
    forward_pid=$!
    trap 'kill "$forward_pid" 2>/dev/null || true' EXIT
    webui=false
    for attempt in $(seq 1 30); do
        if curl --fail --silent --max-time 3 http://127.0.0.1:19999/ > "$STATE/webui.html"; then webui=true; break; fi
        sleep 1
    done
    [[ "$webui" == true ]]
    grep -qi 'open5gs' "$STATE/webui.html"
    mark webui
    kubectl -n "$NS" get pods -o json > "$STATE/images.json"
    ;;
diagnostics)
    kubectl -n "$NS" get pods,deployments,statefulsets,services -o wide > "$STATE/resources.log" 2>&1 || true
    kubectl -n "$NS" get events --sort-by=.lastTimestamp > "$STATE/events.log" 2>&1 || true
    kubectl -n "$NS" logs --all-containers --prefix --tail=200 \
        -l app.kubernetes.io/instance=open5gs > "$STATE/open5gs.log" 2>&1 || true
    kubectl -n "$NS" logs deployment/ueransim-gnb-ues > "$STATE/ues.log" 2>&1 || true
    ;;
clean)
    helm uninstall ueransim-gnb open5gs --namespace "$NS" --ignore-not-found --wait --timeout 3m
    empty=false
    for attempt in $(seq 1 30); do
        remaining=$(kubectl -n "$NS" get pods -o name)
        if [[ -z "$remaining" ]]; then empty=true; break; fi
        sleep 2
    done
    [[ "$empty" == true ]]
    if [[ -f "$STATE/checks.json" && -f "$STATE/images.json" ]]; then
        mark cleanup
        python3 "$ROOT/scripts/tutorials/ueransim.py" record --state "$STATE" --source "$SOURCE"
    fi
    ;;
*) echo "Usage: bash tutorial.sh install|verify|diagnostics|clean" >&2; exit 2 ;;
esac
