#!/bin/bash
set -eu

__help() {
cat << EOF
Create a tls secret for a kubernetes service.
The certificate will be approved by the kubernetes CA.
Usage ./gen-cert.sh my-secret -s adm-controller -n openshift-multus
Args:
    my-secret         name of the secret
Options:
    -s  --service     service of the server
    -n  --namespace   namespace of the server
EOF
}

service=""
namespace=""
if [[ $# -ne 5 ]]; then
    __help
    exit 1
fi
name="$1"
options=$(getopt -l "help,service:,namespace:" -o "hs:n:" -a -- "$@")
eval set -- "$options"
while true
do
case $1 in
-h|--help) 
    __help
    exit 0
    ;;
-s|--service) 
    shift
    service=$1
    ;;
-n|--namespace)
    shift
    export namespace=$1
    ;;
--)
    shift
    break;;
esac
shift
done

if [[ -z $service || -z $namespace || -z $name ]]; then
    __help
    exit 1
fi


csrName=${service}.${namespace}
tmpdir=$(mktemp -d)
echo "Creating certs in tmpdir ${tmpdir} "

cat <<EOF >> ${tmpdir}/csr.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${service}
DNS.2 = ${service}.${namespace}
DNS.3 = ${service}.${namespace}.svc
EOF

openssl genrsa -out ${tmpdir}/tls.key 2048
openssl req -new -key ${tmpdir}/tls.key -subj "/CN=${service}.${namespace}.svc" -out ${tmpdir}/server.csr -config ${tmpdir}/csr.conf

# clean-up any previously created CSR for our service. Ignore errors if not present.
kubectl delete csr ${csrName} 2>/dev/null || true

# create server cert/key CSR and send to k8s API
cat <<EOF | kubectl create -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: ${csrName}
spec:
  groups:
  - system:authenticated
  request: $(cat ${tmpdir}/server.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF

# verify CSR has been created
while true; do
    kubectl get csr ${csrName}
    if [ "$?" -eq 0 ]; then
        break
    fi
done

# approve and fetch the signed certificate
kubectl certificate approve ${csrName}
# verify certificate has been signed
for x in $(seq 10); do
    serverCert=$(kubectl get csr ${csrName} -o jsonpath='{.status.certificate}')
    if [[ ${serverCert} != '' ]]; then
        break
    fi
    sleep 1
done
if [[ ${serverCert} == '' ]]; then
    echo "ERROR: After approving csr ${csrName}, the signed certificate did not appear on the resource. Giving up after 10 attempts." >&2
    exit 1
fi
echo ${serverCert} | openssl base64 -d -A -out ${tmpdir}/tls.crt

echo "Create the secret with CA cert and server cert/key"
kubectl create secret generic ${name} -n ${namespace} --from-file=tls.key=${tmpdir}/tls.key --from-file=tls.crt=${tmpdir}/tls.crt
kubectl get secret ${name} -n ${namespace}