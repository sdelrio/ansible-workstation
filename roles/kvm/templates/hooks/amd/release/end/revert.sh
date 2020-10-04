#!/bin/bash
set -x

# Unload VFIO-PCI Kernel Driver
modprobe -r vfio-pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

# Re-Bind GPU to AMDGPU Driver

DEVS="{{ vm.vga_bus_ids | reverse | join(' ') | replace(':','_') | replace('.','_') }}"

for DEV in $DEVS; do
  echo -n "$DEV -> "
  virsh nodedev-reattach pci_${DEV}
  echo "$DEV" > /sys/bus/pci/devices/$DEV/driver/unbind
  echo "$DEV" > /sys/bus/pci/drivers/vfio-pci/unbind
done
sleep 1

# Rebind VT consoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
# Some machines might have more than 1 virtual console. Add a line for each corresponding VTConsole
echo 1 > /sys/devices/virtual/vtconsole/vtcon1/bind

sleep 2
modprobe amdgpu

#echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

# Restart Display Manager
systemctl start display-manager.service
