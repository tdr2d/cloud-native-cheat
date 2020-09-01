#!/bin/sh

cd /etc/origin/master

# backup master config
cp master-config.yaml master-config.yaml.bak

# patch master config
cat << EOF > /tmp/admissionconfig.yml
    MutatingAdmissionWebhook:
      configuration:
        apiVersion: v1
        disable: false
        kind: DefaultAdmissionConfig
    ValidatingAdmissionWebhook:
      configuration:
        apiVersion: v1
        disable: false
        kind: DefaultAdmissionConfig
EOF
# cp master-config.yaml.bak master-config.yaml
sed -i '/pluginConfig:/r /tmp/admissionconfig.yml' master-config.yaml

# restart master api
master-restart api