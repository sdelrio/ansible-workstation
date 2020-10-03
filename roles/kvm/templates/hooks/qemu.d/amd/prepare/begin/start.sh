#!/bin/bash
# Helpful to read output when debugging
set -x

# Stop display manager
systemctl stop display-manager.service

## Uncomment the following line if you use GDM
#killall gdm-x-session

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/devices/virtual/vtconsole/vtcon1/bind

# Unbind EFI-Framebuffer
#echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind || true

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
sleep 2

# Unbind the GPU from display driver
DEVS="{{ vm.vga_bus_ids | join(' ') | replace(':','_') | replace('.','_') }}"

for DEV in $DEVS; do
  echo -n "$DEV -> "
  virsh nodedev-detach pci_${DEV} || ( sleep 1 ; virsh nodedev-detach pci_${DEV} )
done
sleep 1

# Unload AMD GPU driver
modprobe -r amdgpu

for DEV in $DEVS; do
  echo "vfio-pci" > "/sys/bus/pci/devices/$DEV/driver_override"
  cat "/sys/bus/pci/devices/$DEV/driver_override"
done

# Load VFIO Kernel Module
modprobe vfio-pci
