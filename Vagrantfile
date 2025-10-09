# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Common configuration for all nodes
  config.vm.box = "generic/ubuntu2204"  # Ubuntu 22.04 LTS
  config.vm.box_check_update = false

  # Disable shared folders (not needed for K8s)
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Disable automatic box update checking
   config.vm.boot_timeout = 600

  # Master Node
  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 2048
    libvirt.cpus = 1
    libvirt.driver = "kvm"
    libvirt.nested = true
    libvirt.storage_pool_name = "default"
    libvirt.nested = true
    libvirt.disk_bus = 'virtio'
    libvirt.nic_model_type = 'virtio'
    libvirt.cpu_mode = 'host-passthrough'
    libvirt.machine_type = 'pc-q35-6.2'

    # Common provisioning for all nodes
  config.vm.provision "shell", inline: <<-SHELL
    # Wait for cloud-init to complete
    while [ ! -f /var/lib/cloud/instance/boot-finished ]; do
      echo 'Waiting for cloud-init...'
      sleep 2
    done
  SHELL


  end
  # Kubernetes Control Plane Node
  config.vm.define "k8s-control", primary: true do |control|
    control.vm.hostname = "k8s-control"
    control.vm.network "private_network", 
      ip: "192.168.100.10",
      libvirt__network_name: "vagrant-libvirt",
      libvirt__forward_mode: "veryisolated"

    # Control plane needs more resources
    control.vm.provider :libvirt do |libvirt|
      libvirt.memory = 4096
      libvirt.cpus = 2
      libvirt.storage :file, :size => '20G'
    end

    control.vm.provision "shell", path: "scripts/common.sh"
    control.vm.provision "shell", path: "scripts/control-plane.sh", run: 'always'
  end

  # Kubernetes Worker Node 1
  config.vm.define "k8s-worker1" do |worker|
    worker.vm.hostname = "k8s-worker1"
    worker.vm.network "private_network", 
      ip: "192.168.100.11",
      libvirt__network_name: "vagrant-libvirt",
      libvirt__forward_mode: "veryisolated"

    worker.vm.provider :libvirt do |libvirt|
      libvirt.memory = 3072
      libvirt.cpus = 1
      libvirt.storage :file, :size => '20G'
    end

    worker.vm.provision "shell", path: "scripts/common.sh"
    worker.vm.provision "shell", path: "scripts/worker.sh", run: 'always'
  end

  # Kubernetes Worker Node 2
  config.vm.define "k8s-worker2" do |worker|
    worker.vm.hostname = "k8s-worker2"
    worker.vm.network "private_network", 
      ip: "192.168.100.12",
      libvirt__network_name: "vagrant-libvirt",
      libvirt__forward_mode: "veryisolated"

    worker.vm.provider :libvirt do |libvirt|
      libvirt.memory = 3072
      libvirt.cpus = 1
      libvirt.storage :file, :size => '20G'
    end

    worker.vm.provision "shell", path: "scripts/common.sh"
    worker.vm.provision "shell", path: "scripts/worker.sh", run: 'always'
  end
end

 