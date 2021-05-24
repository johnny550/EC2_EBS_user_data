#!/bin/bash

set -ex 

# Refresh the state of LVM2
vgchange -ay

DEVICE_FS=`blkid -o value -s TYPE ${DEVICE} || echo ""`
# Create a volume named ${DEVICE} if it does not exist
if [ "`echo -n $DEVICE_FS`" == "" ] ; then 
  # wait for the device to be attached
  DEVICENAME=`echo "${DEVICE}" | awk -F '/' '{print $3}'`
  DEVICEEXISTS=''
  while [[ -z $DEVICEEXISTS ]]; do
    echo "checking $DEVICENAME"
    DEVICEEXISTS=`lsblk |grep "$DEVICENAME" |wc -l`
    if [[ $DEVICEEXISTS != "1" ]]; then
      sleep 15
    fi
  done

  # Linux volume manager commands
  pvcreate ${DEVICE}                          # Physical volume creation
  vgcreate data ${DEVICE}                     # Volume group creation. Name = data
  lvcreate --name volume1 -l 100%FREE data    # Logical volume creation. Name = volume1
  mkfs.ext4 /dev/data/volume1                 # Create the file system for the ebs volume using its name. /dev/volume group/logical volume
fi
mkdir -p /data
echo '/dev/data/volume1 /data ext4 defaults 0 0' >> /etc/fstab  # Persist the existence of the volume.
mount /data                                                     # Mount the volume

# install docker either here or in init.cfg
# curl https://get.docker.com | bash
