#!/usr/bin/env bash
#
# Installs kube-prometheus-stack (Prometheus + Grafana + Alertmanager) and
# loads the custom Hello World Grafana dashboard.
#
# Usage: ./scripts/install-monitoring.sh

set -euo pipefail

echo "==> Adding prometheus-community Helm repo"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null
helm repo update >/dev/null

echo "==> Installing kube-prometheus-stack (namespace: monitoring)"
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f monitoring/kube-prometheus-stack-values.yaml \
  --wait --timeout 10m

echo "==> Loading custom Hello World Grafana dashboard"
kubectl apply -f monitoring/grafana-dashboard-configmap.yaml

echo "==> Done. Access Grafana with:"
echo "    kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80"
echo "    Open http://localhost:3000  (user: admin / password: admin123)"
echo ""
echo "==> Access Prometheus with:"
echo "    kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090"
