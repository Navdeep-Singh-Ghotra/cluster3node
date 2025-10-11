# cluster3node
This is a repository on setting up 3 node kubernetes cluster on local machine

Vision --> create a reusable repository to setup kubernetes 3 node cluster on local machine 

Step 1

A. Choose how to create VM's. How much cpu and RAM is needed

Options available --> 1. libvirt + virt-manager 2. QEMU/KVM 3. Vagrant
Chosen Vagrant because i am using it for Development environments and i can use Vagrantfile to leverage the features of "infrastructure as code" to make it versionable, repeatable, collborative, documented and testable

Prerequisite :
1. 

cluster3node/
├── Vagrantfile           # Environment definition
├── bootstrap.sh          # Provisioning script
├── provision/
│   ├── web.sh           # Web server setup
│   ├── db.sh            # Database setup
│   └── redis.sh         # Redis setup
└── README.md

Status --> WIP

B. How to keep track of changes, should i put it in version control ? 

Step 2

Choose 
A. how to install prerequites on the machines. Vanilla kubernetes ?
B. how to create cluster using kubeadm
C. which network plugin we need and why 

Step 3

A. How to connect to kubernetes cluster using kubeconfig
B. Test kubectl and create a deployment to verify if everything is working  


Step 4 

A. Install a monitoring stack. Using helm ?

