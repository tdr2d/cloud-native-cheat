#!/bin/sh

# Prerequisites: Nginx Ingress Controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx
kubectl get ingressclass
# Make sure nginx ingress class exists

# Prerequisites: CertManager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager -n cert-manager --create-namespace --version v1.11.0 --set installCRDs=true


# Configure a clusterIssuer so you won't have to create an Issuer for each Namespace
cat << EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: admin@example.com
    privateKeySecretRef:
      name: letsencrypt
    solvers:
    - http01:
        ingress:
          class:  nginx
EOF

# When you create ingress you have to have a specific annotation
# DNS example.com has to resolve to succeed
kubectl create ingress example-tls --rule="example.com/*=example:80,tls=example-cert" --class nginx \
    --annotation cert-manager.io/cluster-issuer=letsencrypt