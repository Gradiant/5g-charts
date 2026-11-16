#!/usr/bin/env bash
# Runs only in the trusted write job after a successful published-package test.
set -euo pipefail
DIR=tutorials/open5gs-ueransim
REPORT=reports/verified
if cmp -s "$DIR/versions.json" "$REPORT/versions.json"; then
    echo "Documented versions already match; no documentation PR needed."
    exit 0
fi
cp "$REPORT/versions.json" "$DIR/versions.json"
# Reject stale reports if main's commands/values have changed since the release run.
python3 scripts/tutorials/ueransim.py validate --state "$REPORT"
cp "$REPORT/validation.json" "$DIR/validation.json"
open5gs=$(python3 scripts/tutorials/ueransim.py version --chart open5gs)
ueransim=$(python3 scripts/tutorials/ueransim.py version --chart ueransim-gnb)
branch="docs/ueransim-$open5gs-$ueransim"
if [[ -n "$(gh pr list --head "$branch" --state open --json number --jq '.[].number')" ]]; then
    echo "A documentation PR already exists; preserving its review changes."
    exit 0
fi
git switch -c "$branch"
git config user.name 'github-actions[bot]'
git config user.email '41898282+github-actions[bot]@users.noreply.github.com'
git add "$DIR/versions.json" "$DIR/validation.json"
git commit -m "Validate UERANSIM tutorial with Open5GS $open5gs and UERANSIM $ueransim"
git push origin "$branch"
python3 - <<'PY' > reports/tutorial-pr-body.md
import json
from pathlib import Path
p=json.loads(Path('reports/verified/validation.json').read_text())
print('Update the tutorial pins after verifying the actual published OCI packages.\n')
print('All functional checks, including both UE sessions, tunnel traffic and cleanup, passed.')
print('\nValidation: '+p['run_url'])
print('\nReview these changes before merging. Pages is updated only after another successful published-package test on main.')
PY
gh pr create --base main --head "$branch" \
    --title "Update verified Open5GS UERANSIM tutorial ($open5gs / $ueransim)" \
    --body-file reports/tutorial-pr-body.md
# Explicit dispatches avoid depending on automatic runs from bot-created PRs.
gh workflow run tutorial-ueransim.yml --ref "$branch"
gh workflow run lint-test.yaml --ref "$branch"
