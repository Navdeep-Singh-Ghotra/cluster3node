#!/bin/bash
set -e

echo "=== Minimal Kubernetes Setup ==="

# Wait for cloud-init
while [ ! -f /var/lib/cloud/instance/boot-finished ]; do
    echo "Waiting for cloud-init..."
    sleep 5
done

# Basic packages
apt-get update
apt-get install -y curl wget

# Install Docker (quick method)
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Configure Docker
mkdir -p /etc/docker
cat <<EOF | tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "storage-driver": "overlay2"
}
EOF

systemctl enable docker
systemctl start docker
usermod -aG docker vagrant

# Disable swap
swapoff -a
sed -i '/swap/d' /etc/fstab

# Install Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

echo "Minimal setup complete"