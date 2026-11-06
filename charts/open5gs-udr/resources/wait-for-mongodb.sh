#!/bin/bash
set -euo pipefail

if [[ ! "${MONGODB_WAIT_TIMEOUT_SECONDS:-}" =~ ^[1-9][0-9]*$ ]] ||
   [[ ! "${MONGODB_WAIT_INTERVAL_SECONDS:-}" =~ ^[1-9][0-9]*$ ]]; then
    echo "MongoDB wait timeout and retry interval must be positive integers" >&2
    exit 1
fi

# Bound each client attempt as well as the overall wait, including DNS failures.
deadline=$(( $(date +%s) + MONGODB_WAIT_TIMEOUT_SECONDS ))
echo "Waiting for MongoDB (timeout: ${MONGODB_WAIT_TIMEOUT_SECONDS}s)"
while true; do
    remaining=$(( deadline - $(date +%s) ))
    if (( remaining <= 0 )); then
        echo "Timed out waiting for MongoDB; check database availability and dbURI" >&2
        exit 1
    fi
    attempt_seconds=$remaining
    if (( attempt_seconds > 10 )); then
        attempt_seconds=10
    fi
    if timeout -k 1 "${attempt_seconds}s" mongosh "$DB_URI" --norc --quiet \
        --eval 'if (db.adminCommand({ping: 1}).ok !== 1) quit(1)' >/dev/null 2>&1; then
        echo "MongoDB is ready"
        exit 0
    fi
    remaining=$(( deadline - $(date +%s) ))
    if (( remaining > 0 )); then
        interval=$MONGODB_WAIT_INTERVAL_SECONDS
        if (( interval > remaining )); then
            interval=$remaining
        fi
        sleep "$interval"
    fi
done
