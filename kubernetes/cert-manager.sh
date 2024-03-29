#!/bin/sh

# 1. Deploy the nginx IngressController
# 
#
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx
# Carefull, this helm charts deploys an LoadBalancer Service
kubectl get ingressclass
# Make sure nginx ingress class exists


# 2. Deploy CertManager 
# 
#
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


# 3. Create a ClusterIP Service (that will be used by the ingress)
# 
kubectl expose deployment nextcloud --name my-svc --port=80 --target-port=80 

# 4. Configure DNS A record to target the K8S (L4) load balancer pointing to the IngressController
# When you create ingress you have to have a specific annotation
# DNS example.com has to resolve to succeed

# 5. Create the ingress with proper configuration
# Replace example.com by your DNS
# Replace my-svc by your svc name
# Replace 80 by the svc port
kubectl create ingress example-tls --rule="example.com/*=my-svc:80,tls=my-secret" --class nginx \
    --annotation cert-manager.io/cluster-issuer=letsencrypt