#!/usr/bin/env bash
# Based upon https://www.apalrd.net/posts/2023/pve_cloud/

# Create template
# args:
#  vm_id
#  vm_name
#  file name in the current directory
function create_template() {
    # Print all of the configuration
    echo "Creating template $2 ($1)"

    # Create new VM
    # Feel free to change any of these to your liking
    qm create "$1" --name "$2" --ostype l26
    # Set networking to default bridge
    qm set "$1" --net0 virtio,bridge=vmbr0
    # Set display to serial
    qm set "$1" --serial0 socket --vga serial0
    # Set memory, cpu, type defaults
    # If you are in a cluster, you might need to change cpu type
    qm set "$1" --memory 1024 --cores 4 --cpu host
    # Set boot device to new file
    qm set "$1" --scsi0 "${storage}":0,import-from="$(pwd)"/"$3",discard=on
    # Set scsi hardware as default boot disk using virtio scsi single
    qm set "$1" --boot order=scsi0 --scsihw virtio-scsi-single
    # Enable Qemu guest agent in case the guest has it available
    qm set "$1" --agent enabled=1,fstrim_cloned_disks=1
    # Add cloud-init device
    qm set "$1" --ide2 "${storage}":cloudinit
    # Set CI ip config
    # IP6 = auto means SLAAC (a reliable default with no bad effects on non-IPv6 networks)
    # IP = DHCP means what it says, so leave that out entirely on non-IPv4 networks to avoid DHCP delays
    qm set "$1" --ipconfig0 "ip6=auto,ip=dhcp"
    # Import the ssh keyfile
    qm set "$1" --sshkeys "${ssh_keyfile}"
    # If you want to do password-based auth instaed
    # Then use this option and comment out the line above
    # qm set "$1" --cipassword password
    # Add the user
    qm set "$1" --ciuser "${username}"
    # Resize the disk to 8G, a reasonable minimum. You can expand it more later.
    # If the disk is already bigger than 8G, this will fail, and that is okay.
    qm disk resize "$1" scsi0 8G
    # Make it a template
    qm template "$1"

    # Remove file when done
    rm "$3"
}


# Path to your ssh authorized_keys file
# Alternatively, use /etc/pve/priv/authorized_keys if you are already authorized
# on the Proxmox system
#  export ssh_keyfile=/root/id_rsa.pub
export ssh_keyfile=/etc/pve/priv/authorized_keys
# Username to create on VM template
export username=tom

# Name of your storage
export storage=ceph_pool

## Debian
# Buster (10)
wget "https://cloud.debian.org/images/cloud/buster/latest/debian-10-genericcloud-amd64.qcow2"
create_template 9000 "temp-debian-10" "debian-10-genericcloud-amd64.qcow2"
# Bullseye (11)
wget "https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"
create_template 9001 "temp-debian-11" "debian-11-genericcloud-amd64.qcow2"
# Bookworm (12)
wget "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-arm64.qcow2"
create_template 9002 "temp-debian-12" "debian-12-genericcloud-amd64.qcow2"
# # Bookworm (12 dailies - not yet released)
# wget "https://cloud.debian.org/images/cloud/bookworm/daily/latest/debian-12-genericcloud-amd64-daily.qcow2"
# create_template 902 "temp-debian-12-daily" "debian-12-genericcloud-amd64-daily.qcow2"

## Ubuntu
# 20.04 LTS (Focal Fossa)
wget "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
create_template 9010 "temp-ubuntu-20-04-lts" "ubuntu-20.04-server-cloudimg-amd64.img"
# 22.04 LTS (Jammy Jellyfish)
wget "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
create_template 9011 "temp-ubuntu-22-04-lts" "ubuntu-22.04-server-cloudimg-amd64.img"
# 23.04 (Lunar Lobster)
wget "https://cloud-images.ubuntu.com/releases/23.04/release/ubuntu-23.04-server-cloudimg-amd64.img"
create_template 9012 "temp-ubuntu-23-04" "ubuntu-23.04-server-cloudimg-amd64.img"
# # 23.04 (Lunar Lobster) - daily builds
# wget "https://cloud-images.ubuntu.com/lunar/current/lunar-server-cloudimg-amd64.img"
# create_template 912 "temp-ubuntu-23-04-daily" "lunar-server-cloudimg-amd64.img"

## Fedora 37
# Image is compressed, so need to uncompress first
wget https://download.fedoraproject.org/pub/fedora/linux/releases/37/Cloud/x86_64/images/Fedora-Cloud-Base-37-1.7.x86_64.raw.xz
xz -d -v Fedora-Cloud-Base-37-1.7.x86_64.raw.xz
create_template 9020 "temp-fedora-37" "Fedora-Cloud-Base-37-1.7.x86_64.raw"

## Fedora 38
# Image is compressed, so need to uncompress first
wget https://download.fedoraproject.org/pub/fedora/linux/releases/38/Cloud/x86_64/images/Fedora-Cloud-Base-38-1.6.x86_64.raw.xz
xz -d -v Fedora-Cloud-Base-38-1.6.x86_64.raw.xz
create_template 9021 "temp-fedora-38" "Fedora-Cloud-Base-38-1.6.x86_64.raw"

# ## CentOS Stream
# # Stream 8
# wget https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20220913.0.x86_64.qcow2
# create_template 930 "temp-centos-8-stream" "CentOS-Stream-GenericCloud-8-20220913.0.x86_64.qcow2"
# # Stream 9 (daily) - they don't have a 'latest' link?
# wget https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20230123.0.x86_64.qcow2
# create_template 931 "temp-centos-9-stream-daily" "CentOS-Stream-GenericCloud-9-20230123.0.x86_64.qcow2"
