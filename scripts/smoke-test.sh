#!/usr/bin/env bash
# Usage: ./scripts/smoke-test.sh http://localhost:8080
set -euo pipefail

BASE_URL="${1:-http://localhost:8080}"
PATHS=("/healthz" "/" "/index.html" "/products.html" "/payment.html")

fail=0
for p in "${PATHS[@]}"; do
    code=$(curl -s -o /dev/null -w "%{http_code}" "${BASE_URL}${p}" || true)
    if [[ "$code" == "200" ]]; then
        echo "[ OK ] ${p} -> ${code}"
    else
        echo "[FAIL] ${p} -> ${code}"
        fail=1
    fi
done

exit $fail
