#!/usr/bin/env bash
# Loads monitoring/grafana/nexvion-dashboard.json into Grafana (kube-prometheus-stack sidecar picks it up).
# Run from the repo root:  bash monitoring/grafana/load-dashboard.sh
set -euo pipefail

kubectl -n monitoring create configmap nexvion-dashboard \
    --from-file=nexvion-dashboard.json=monitoring/grafana/nexvion-dashboard.json \
    --dry-run=client -o yaml | kubectl apply -f -

kubectl -n monitoring label configmap nexvion-dashboard grafana_dashboard=1 --overwrite

echo "Dashboard loaded. Open Grafana -> Dashboards -> 'Nexvion - Application & Cluster Overview' (wait ~30s)."
