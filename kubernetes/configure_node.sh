#!/bin/bash

set -euo pipefail

# Instal a debian node using kubeadm
cd /tmp
apt-get update
apt-get -y install conntrack
echo '1' > /proc/sys/net/ipv4/ip_forward
modprobe br_netfilter

# CONTAINERD : https://github.com/containerd/containerd/blob/main/docs/getting-started.md
mkdir -p /opt/cni/bin
curl -L https://github.com/containerd/containerd/releases/download/v1.7.2/containerd-1.7.2-linux-amd64.tar.gz | tar -xzvC /usr/local
curl -L https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz | tar -xzvC /opt/cni/bin
curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.27.0/crictl-v1.27.0-linux-amd64.tar.gz | tar -xzvC /usr/local/bin
curl -Lo /usr/lib/systemd/system/containerd.service https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
curl -LO https://github.com/opencontainers/runc/releases/download/v1.1.7/runc.amd64 && install -m 755 runc.amd64 /usr/local/sbin/runc
chmod +x -R /usr/local/bin /opt/cni/bin

# BINARIES
K8S_RELEASE="$(curl -sSL https://dl.k8s.io/release/stable.txt)"
curl -LO https://dl.k8s.io/release/${K8S_RELEASE}/bin/linux/amd64/kubeadm
curl -LO https://dl.k8s.io/release/${K8S_RELEASE}/bin/linux/amd64/kubectl
curl -LO https://dl.k8s.io/release/${K8S_RELEASE}/bin/linux/amd64/kubelet
chmod +x kubeadm kubectl kubelet
mv kubeadm kubectl kubelet /usr/bin/

# CONFIG https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
RELEASE_VERSION="v0.15.1"
curl -Lo /etc/systemd/system/kubelet.service https://raw.githubusercontent.com/kubernetes/release/${RELEASE_VERSION}/cmd/kubepkg/templates/latest/deb/kubelet/lib/systemd/system/kubelet.service
mkdir -p /etc/systemd/system/kubelet.service.d
curl -Lo /etc/systemd/system/kubelet.service.d/10-kubeadm.conf https://raw.githubusercontent.com/kubernetes/release/${RELEASE_VERSION}/cmd/kubepkg/templates/latest/deb/kubeadm/10-kubeadm.conf

# Start services
systemctl daemon-reload
systemctl enable --now containerd
systemctl enable --now kubelet

echo "Run kubeadm init to start a new cluster"
echo "Run kubeadm join to join to an existing cluster"
journalctl -u kubelet -f
