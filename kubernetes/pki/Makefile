ca_bundle:
	ca_bundle=$(kubectl get configmap -n kube-system extension-apiserver-authentication -o=jsonpath='{.data.client-ca-file}' | base64 | tr -d '\n')
	sed -i -e "s/CA_BUNDLE_HERE/$ca_bundle/g" mutating-webhook.yaml
