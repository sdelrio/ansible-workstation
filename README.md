# Workstation ansible

Ansible playbook to install software used in workstation. It expect the user to have sudo privileges without asking for password. So if need to introduce password need to add ansible parameter:

```
 -K, --ask-become-pass
        ask for privilege escalation password
```

# Groups

Can select groups to install based on on the tags

# VMs

```
ansible-playbook main.yml -t kvm
```

## Software

* qemu
* libvirt
* virt manager
* OVMF (UEFI Bios)
* nfs to share files between hosts

## Configuration

* Activate IOMMU on kernel boot
* Activate Hugepages on kernel boot
* Initramfs for 2nd vga passthrough
* Fix for Win 1803+ ignore msrs
* Disable vgas from arbitration (usefull with 2+ vgas)
* Hugepages settings
* Add kvm groups to current user

# Develop tools

```
ansible-playbook main.yml -t tools
```

## Software

* vim
* ssh server
* git
* zsh
* powerline fonts
* zsh
* Visualstudio Code
* docker & docker-ocmpose
* kubectl
* tilt.dev

# Photo

```
ansible-playbook main.yml -t photo
```

## Software

* gnome-color manager
* argyll
* darktable
* sshfs (in my case I have sd reader on other computer)
* rocm driverse for amd vga (openc darktable acceleration)

# Gaming

```
ansible-playbook main.yml -t gaming
```

## Software

* Lutris
* Steam

