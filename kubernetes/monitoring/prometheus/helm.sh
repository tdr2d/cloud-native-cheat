
# Install
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus-19.5.0 prometheus-community/prometheus

# Upgrade Values
helm upgrade prometheus-19.5.0