#!/usr/bin/env bash
set -euo pipefail

# Keep local documentation generation reproducible across developer machines.
readonly HELM_DOCS_IMAGE="jnorwood/helm-docs:v1.14.2"
repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo "Usage: $0 [charts/open5gs-upf charts/mongodb ...]"
    echo "Without arguments, generates Open5GS and MongoDB documentation."
    exit 0
fi

if (( $# )); then
    chart_dirs=("$@")
else
    chart_dirs=("$repo_root"/charts/open5gs "$repo_root"/charts/open5gs-* "$repo_root"/charts/mongodb)
fi

chart_names=()
for chart_dir in "${chart_dirs[@]}"; do
    chart_dir="${chart_dir%/}"
    chart_dir="${chart_dir#"$repo_root"/}"
    chart_dir="${chart_dir#./}"
    chart_name="${chart_dir#charts/}"
    if [[ "$chart_dir" != charts/* || ! "$chart_name" =~ ^[a-zA-Z0-9_-]+$ ||
          ! -f "$repo_root/$chart_dir/Chart.yaml" ||
          ! -f "$repo_root/$chart_dir/README.md.gotmpl" ]]; then
        echo "Expected a chart directory with Chart.yaml and README.md.gotmpl: $chart_dir" >&2
        exit 1
    fi
    chart_names+=("$chart_dir")
done
printf -v charts_csv '%s,' "${chart_names[@]}"
charts_csv="${charts_csv%,}"

docker run --rm \
    --user "$(id -u):$(id -g)" \
    --volume "$repo_root:/helm-docs" \
    --workdir /helm-docs \
    "$HELM_DOCS_IMAGE" \
    --chart-search-root=charts \
    --chart-to-generate="$charts_csv" \
    --template-files=./_helm-docs.gotmpl \
    --template-files=README.md.gotmpl
