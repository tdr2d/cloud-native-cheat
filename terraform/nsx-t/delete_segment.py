import requests
import sys
import json
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

nsx = "192.168.95.6"
user = "admin"
pw = "VMware1!VMware1!"
segments = [
    "seg-ocp4-n-default-0",
    "seg-ocp4-n-kube-node-lease-0",
    "seg-ocp4-n-kube-public-0",
    "seg-ocp4-n-kube-system-0",
    "seg-ocp4-n-nsx-system-0",
    "seg-ocp4-n-openshift-apiserver-operator-0",
    "seg-ocp4-n-openshift-authentication-0",
    "seg-ocp4-n-openshift-authentication-operator-0",
    "seg-ocp4-n-openshift-cloud-credential-operator-0",
    "seg-ocp4-n-openshift-cluster-machine-approver-0",
    "seg-ocp4-n-openshift-cluster-node-tuning-operator-0",
    "seg-ocp4-n-openshift-cluster-samples-operator-0",
    "seg-ocp4-n-openshift-cluster-storage-operator-0",
    "seg-ocp4-n-openshift-cluster-version-0",
    "seg-ocp4-n-openshift-config-0",
    "seg-ocp4-n-openshift-config-managed-0",
    "seg-ocp4-n-openshift-controller-manager-0",
    "seg-ocp4-n-openshift-controller-manager-operator-0",
    "seg-ocp4-n-openshift-dns-operator-0",
    "seg-ocp4-n-openshift-dns-operator-0",
    "seg-ocp4-n-openshift-etcd-operator-0",
    "seg-ocp4-n-openshift-image-registry-0",
    "seg-ocp4-n-openshift-infra-0",
    "seg-ocp4-n-openshift-ingress-operator-0",
    "seg-ocp4-n-openshift-insights-0",
    "seg-ocp4-n-openshift-kni-infra-0",
    "seg-ocp4-n-openshift-kube-apiserver-0",
    "seg-ocp4-n-openshift-kube-apiserver-operator-0",
    "seg-ocp4-n-openshift-kube-controller-manager-0",
    "seg-ocp4-n-openshift-kube-controller-manager-operator-0",
    "seg-ocp4-n-openshift-kube-proxy-0",
    "seg-ocp4-n-openshift-kube-scheduler-0",
    "seg-ocp4-n-openshift-kube-scheduler-operator-0",
    "seg-ocp4-n-openshift-kube-storage-version-migrator-operator-0",
    "seg-ocp4-n-openshift-machine-api-0",
    "seg-ocp4-n-openshift-machine-config-operator-0",
    "seg-ocp4-n-openshift-marketplace-0",
    "seg-ocp4-n-openshift-monitoring-0",
    "seg-ocp4-n-openshift-multus-0",
    "seg-ocp4-n-openshift-network-operator-0",
    "seg-ocp4-n-openshift-openstack-infra-0",
    "seg-ocp4-n-openshift-operator-lifecycle-manager-0",
    "seg-ocp4-n-openshift-operators-0",
    "seg-ocp4-n-openshift-ovirt-infra-0",
    "seg-ocp4-n-openshift-service-ca-operator-0",
    "seg-ocp4-n-openshift-service-catalog-apiserver-operator-0",
    "seg-ocp4-n-openshift-service-catalog-controller-manager-operator-0",
    "seg-ocp4-n-openshift-user-workload-monitoring-0",
    "seg-ocp4-n-openshift-vsphere-infra-0",
  ]

headers = {
    'Content-Type': 'application/json',
    'X-Allow-Overwrite': 'true'
}


def get_all_segments():
    data = ""
    response = requests.get(f'https://{nsx}/policy/api/v1/infra/segments/', headers=headers, data=data, verify=False, auth=(user, pw))
    return response


def delete_segment(segment_id):
    response = requests.delete(f'https://{nsx}/policy/api/v1/infra/segments/{segment_id}?force=true', headers=headers, verify=False, auth=(user, pw))
    return response


if __name__ == "__main__":
    rget = get_all_segments()
    if not rget:
        print(rget.text)
        sys.exit(1)

    for item in json.loads(rget.text).get('results', []):
        print(item)
        if item['display_name'] in segments:
            rdelete = delete_segment(item['relative_path'])
            print(rdelete.text)