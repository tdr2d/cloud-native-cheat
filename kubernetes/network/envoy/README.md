# Manually Get K8S endpoints

```bash
## Get all port mappings frin NodePort Service
## in port:nodePort format, port is external, nodePort is internal
k get svc -A -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.port}}:{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}'

## Get all Node external IPs
k get nodes -o go-template='{{range .items}}{{range.status.addresses}}{{if eq .type "ExternalIP"}}{{.address}}{{"\n"}}{{end}}{{end}}{{end}}'

## Get all Node internal IPs
k get nodes -o go-template='{{range .items}}{{range.status.addresses}}{{if eq .type "InternalIP"}}{{.address}}{{"\n"}}{{end}}{{end}}{{end}}'

## Envoy : Static TCP configuration
envoy -c tcp.static.envoyyaml
```

## service discovery xSD, is possible using dynamic FS 
see https://www.envoyproxy.io/docs/envoy/latest/start/quick-start/configuration-dynamic-filesystem


#
#
# YGGDRASIL
- Yggdrasil is a service discovery which discovers kubernetes ressources
- Official doc : https://github.com/uswitch/yggdrasil/blob/master/docs/GETTINGSTARTED.md


```bash
kubectl create serviceaccount yggdrasil-sa

cat <<EOF | kubectl apply -f -
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: '*'
  name: yggdrasil-read-only
rules:
- apiGroups: ["extensions"]
  resources: ["ingresses"]
  verbs: ["get", "list", "watch"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: yggdrasil-sa-binding
subjects:
- kind: ServiceAccount
  name: yggdrasil-sa
  namespace: default
roleRef:
  kind: ClusterRole
  name: yggdrasil-read-only
  apiGroup: rbac.authorization.k8s.io
EOF


# configure yggdrasil.conf.json
# get the api master endpoint
# create the serviceaccount token 
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: yggdrasil-token
  annotations:
    kubernetes.io/service-account.name: yggdrasil-sa
type: kubernetes.io/service-account-token
EOF

# Copy ca.crt and token in base64 in yggdrasil.conf.json
kubectl get secret yggdrasil-token -o yaml

docker run -d -v /path/to/config.yaml:/config.yaml -v /path/to/ca.crt:/ca.crt quay.io/uswitch/yggdrasil:v0.11.0 --config=config.yaml --debug --upstream-port=80

```