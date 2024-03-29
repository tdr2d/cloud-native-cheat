#!/bin/sh

# Prerequisites: Install Nginx Ingress Controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx
kubectl get ingressclass
# Make sure nginx ingress class exists

# Prerequisites: Install CertManager
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager -n cert-manager --create-namespace --version v1.11.0 --set installCRDs=true


# Configure a clusterIssuer so you won't have to create an Issuer for each Namespace
echo "Write your email :"
export EMAIL=$(read email; echo $email)
cat << EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ${EMAIL}
    privateKeySecretRef:
      name: letsencrypt
    solvers:
    - http01:
        ingress:
          class:  nginx
EOF

# When you create ingress you have to have a specific annotation
# DNS example.com has to resolve to succeed
kubectl expose deployment nextcloud --port=80 --target-port=80 
kubectl create ingress example-tls --rule="example.com/*=example:80,tls=example-cert" --class nginx \
    --annotation cert-manager.io/cluster-issuer=letsencrypt