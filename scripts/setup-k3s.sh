#!/usr/bin/env bash
# Run from the repo root on the Ubuntu VM:  bash scripts/setup-k3s.sh
set -euo pipefail

echo "[1/5] Installing k3s (if missing)"
if ! command -v k3s >/dev/null 2>&1; then
    curl -sfL https://get.k3s.io | sh -
fi
sudo k3s kubectl wait --for=condition=Ready node --all --timeout=180s

echo "[2/5] kubeconfig for current user"
mkdir -p "$HOME/.kube"
sudo cp /etc/rancher/k3s/k3s.yaml "$HOME/.kube/config"
sudo chown "$(id -u):$(id -g)" "$HOME/.kube/config"
chmod 600 "$HOME/.kube/config"
export KUBECONFIG="$HOME/.kube/config"

echo "[3/5] kubeconfig for Jenkins user"
sudo mkdir -p /var/lib/jenkins/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /var/lib/jenkins/.kube/config
sudo chown -R jenkins:jenkins /var/lib/jenkins/.kube
sudo chmod 600 /var/lib/jenkins/.kube/config

echo "[4/5] Installing Helm (if missing)"
if ! command -v helm >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

echo "[5/5] Installing Prometheus + Grafana (kube-prometheus-stack)"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install kps prometheus-community/kube-prometheus-stack \
    --namespace monitoring --create-namespace \
    -f monitoring/prometheus/values.yaml \
    --wait --timeout 10m

echo
echo "Done."
echo "Grafana    : http://<vm-ip>:32000   (user: admin)"
echo "Prometheus : http://<vm-ip>:32090"
echo "Grafana password:"
kubectl get secret -n monitoring kps-grafana -o jsonpath='{.data.admin-password}' | base64 -d; echo
