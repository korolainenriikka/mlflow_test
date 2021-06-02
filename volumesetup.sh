#!/bin/bash

sudo parted -a optimal /dev/vdb mklabel gpt && sudo parted -a optimal /dev/vdb mkpart primary 0% 100% &&
sudo mkfs.ext4 /dev/vdb1 &&
sudo e2label /dev/vdb1 mnist-volume &&

sudo mkdir /media/volume &&
sudo mount /dev/vdb1 /media/volume &&

cd /media/volume &&
sudo mkdir test_data &&
sudo chown ubuntu test_data && cd ~
