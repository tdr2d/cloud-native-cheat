provider "nsxt" {
  host                     = var.nsx_manager
  username                 = var.nsx_username
  password                 = var.nsx_password
  allow_unverified_ssl     = true
  max_retries              = 10
  retry_min_delay          = 500
  retry_max_delay          = 5000
  retry_on_status_codes    = [429]
}

variable "ocp_segments" {
  description = "OCP segment"
  type        = list(string)
  default     = [
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
}


resource "nsxt_policy_segment" "ocp" {
  count = length(var.ocp_segments)
  display_name  = var.ocp_segments[count.index]
  # transport_zone_path = "global-overlay"
  # connectivity_path   = nsxt_policy_tier1_gateway.t1_gateway.path

  # subnet {
  #   cidr        = "12.12.1.1/24"
  #   dhcp_ranges = ["12.12.1.100-12.12.1.160"]

  #   dhcp_v4_config {
  #     server_address = "12.12.1.2/24"
  #     lease_time     = 36000

  #     dhcp_option_121 {
  #       network  = "6.6.6.0/24"
  #       next_hop = "1.1.1.21"
  #     }
  #   }
  # }
}
