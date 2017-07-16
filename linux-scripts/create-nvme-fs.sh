#!/usr/bin/env bash

sudo fdisk /dev/nvme0n1 <<EOF
n
p
1


w
EOF

sleep 3

sudo mkfs.ext4 /dev/nvme0n1p1 <<EOF
y
EOF

sudo mkdir /media/nvme1
sudo mount /dev/nvme0n1p1 /media/nvme1
sudo mkdir /media/nvme1/data
sudo chown ubuntu:ubuntu /media/nvme1/data

