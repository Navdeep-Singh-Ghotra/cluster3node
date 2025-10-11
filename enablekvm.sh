#!/bin/bash
# enable-kvm.sh

echo "=== Enabling KVM Support ==="

# Check CPU virtualization support
echo "1. Checking CPU virtualization support..."
if [ $(egrep -c '(vmx|svm)' /proc/cpuinfo) -eq 0 ]; then
    echo "ERROR: CPU virtualization not supported or disabled in BIOS"
    echo "Please enable VT-x/AMD-V in your BIOS settings"
    echo "Look for options like:"
    echo "  - Intel Virtualization Technology (VT-x)"
    echo "  - AMD-V"
    echo "  - SVM Mode"
    exit 1
else
    echo "✓ CPU virtualization support detected"
fi

# Install KVM packages
echo "2. Installing KVM packages..."
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients virt-manager bridge-utils

# Load KVM modules
echo "3. Loading KVM modules..."
if grep -q "GenuineIntel" /proc/cpuinfo; then
    sudo modprobe kvm_intel
else
    sudo modprobe kvm_amd
fi
sudo modprobe kvm

# Verify modules are loaded
echo "4. Verifying KVM modules..."
if lsmod | grep -q kvm; then
    echo "✓ KVM modules loaded successfully"
else
    echo "✗ Failed to load KVM modules"
    exit 1
fi

# Configure user permissions
echo "5. Configuring user permissions..."
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

# Restart services
echo "6. Restarting libvirt service..."
sudo systemctl enable libvirtd
sudo systemctl restart libvirtd

# Verify KVM is working
echo "7. Verifying KVM..."
if [ -e /dev/kvm ]; then
    echo "✓ KVM is available at /dev/kvm"
else
    echo "✗ /dev/kvm not found - KVM not working properly"
    exit 1
fi

echo "=== KVM Setup Complete ==="
echo "Please log out and back in for group changes to take effect"
echo "Or run: newgrp libvirt"