#!/bin/bash
set -e

echo "=== Starting Worker Node Setup ==="

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Wait for control plane to be ready
log "Waiting for control plane to be ready..."

MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    # Try to copy join command from control plane
    if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -o PasswordAuthentication=no vagrant@192.168.100.10 "test -f /home/vagrant/join-command.txt"; then
        log "Join command found! Copying from control plane..."
        scp -o StrictHostKeyChecking=no vagrant@192.168.100.10:/home/vagrant/join-command.txt /tmp/
        break
    fi
    
    log "Control plane not ready yet... (attempt $((RETRY_COUNT+1))/$MAX_RETRIES)"
    RETRY_COUNT=$((RETRY_COUNT+1))
    sleep 10
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    log "ERROR: Could not retrieve join command from control plane"
    log "Please check if control plane is running and accessible"
    log "You can manually join later with: vagrant ssh k8s-control -c 'cat /home/vagrant/join-command.txt'"
    exit 1
fi

# Join the cluster
log "Joining Kubernetes cluster..."
bash /tmp/join-command.txt

if [ $? -eq 0 ]; then
    log "Worker node successfully joined the cluster!"
    
    # Copy kubeconfig from control plane (optional)
    log "Setting up kubectl configuration..."
    mkdir -p /home/vagrant/.kube
    scp -o StrictHostKeyChecking=no vagrant@192.168.100.10:/home/vagrant/.kube/config /home/vagrant/.kube/config
    chown -R vagrant:vagrant /home/vagrant/.kube
    
    log "Worker node setup completed successfully!"
else
    log "ERROR: Failed to join cluster"
    log "Check kubelet logs: sudo journalctl -u kubelet -f"
    exit 1
fi