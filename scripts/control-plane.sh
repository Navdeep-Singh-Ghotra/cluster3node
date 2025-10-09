#!/bin/bash
set -e

echo "=== Minimal Control Plane Setup ==="

# Check if already initialized
if [ -f /etc/kubernetes/admin.conf ]; then
    echo "Kubernetes already initialized. Skipping."
    exit 0
fi

# Initialize cluster
echo "Initializing Kubernetes control plane..."
kubeadm init \
  --apiserver-advertise-address=192.168.100.10 \
  --pod-network-cidr=10.244.0.0/16 \
  --ignore-preflight-errors=all

# Setup kubectl
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Install Flannel
sudo -u vagrant kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# Remove taints
sudo -u vagrant kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# Save join command
kubeadm token create --print-join-command > /home/vagrant/join-command.txt
chown vagrant:vagrant /home/vagrant/join-command.txt

echo "Control plane setup complete!"
echo "Join command: $(cat /home/vagrant/join-command.txt)"