#!/bin/bash

set -e


# Graylog config
Activated your Logs Data Platform account.
Created at least one Stream and get its token. https://help.ovhcloud.com/csm/fr-logs-data-platform-quick-start?id=kb_article_view&sysparm_article=KB0050058

# Declare variables
export LDP_ACCESS_POINT=gra1.logs.ovh.com 
echo -n "Type LDP_TOKEN (hidden):"
export LDP_TOKEN=$(read -s password; echo $password)

# K8s setup
kubectl create namespace logging
kubectl -n logging create secret generic ldp-token --from-literal=ldp-token=${LDP_TOKEN}

# Helm https://github.com/fluent/helm-charts/tree/main/charts/fluent-bit
helm repo add fluent https://fluent.github.io/helm-charts

# General helm values for fluentbit helm chart
# fluent-bit-values.yml
cat << EOF > fluent-bit-values.yml
env:
   - name: LDP_TOKEN_SECRET
     valueFrom:
         secretKeyRef:
             name: ldp-token
             key: ldp-token
config:
    filters: |
        [FILTER]
            Name kubernetes
            Match kube.*
            Merge_Log On
            Keep_Log Off
            K8S-Logging.Parser On
            K8S-Logging.Exclude On

        [FILTER]
            Name record_modifier
            Match *
            Record X-OVH-TOKEN \${LDP_TOKEN_SECRET}

        [FILTER]
            Name nest
            Match *
            Wildcard pod_name
            Operation lift
            Nested_under kubernetes
            Add_prefix kubernetes_

        [FILTER]
            Name modify
            Match *
            Copy kubernetes_pod_name host

        [FILTER]
            Name modify
            Match *
            Add log "none"
    outputs: |
        [OUTPUT]
            Name gelf
            Match kube.*
            Host ${LDP_ACCESS_POINT}
            Port 12202
            Mode tls
            tls On
            Compress False
            Gelf_Short_Message_Key log
EOF

helm upgrade --install -n logging  -f fluent-bit-values.yml fluent-bit fluent/fluent-bit
helm show values -n logging fluent/fluent-bit