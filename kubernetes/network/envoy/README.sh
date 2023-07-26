### Get K8S endpoints

# Get all port mappings frin NodePort Service
# in port:nodePort format, port is external, nodePort is internal
k get svc -A -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.port}}:{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}'

# Get all Node external IPs
k get nodes -o go-template='{{range .items}}{{range.status.addresses}}{{if eq .type "ExternalIP"}}{{.address}}{{"\n"}}{{end}}{{end}}{{end}}'

# Get all Node internal IPs
k get nodes -o go-template='{{range .items}}{{range.status.addresses}}{{if eq .type "InternalIP"}}{{.address}}{{"\n"}}{{end}}{{end}}{{end}}'

# Envoy : Static TCP configuration
envoy -c tcp.static.envoyyaml

# service discovery xSD, is possible using dynamic FS see https://www.envoyproxy.io/docs/envoy/latest/start/quick-start/configuration-dynamic-filesystem
