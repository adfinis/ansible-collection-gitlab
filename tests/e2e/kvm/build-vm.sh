#!/bin/env bash

cd $(dirname "$0")

# check for and download Debian base image if necessary
test ! -e /var/lib/libvirt/images/debian-12-generic-amd64.qcow2 && \
wget -c -P /tmp https://cdimage.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2 && \
sudo mv /tmp/debian-12-generic-amd64.qcow2 /var/lib/libvirt/images/debian-12-generic-amd64.qcow2

awk -v key="$(cat id_ed25519.pub)" 'gsub(/<SSH_KEY>/, key)1' cloud-init.cfg.template > cloud-init.cfg

sudo virt-install \
  --name gitlab_e2e_ansible \
  --memory 8192 \
  --vcpus 4 \
  --disk=size=12,backing_store=/var/lib/libvirt/images/debian-12-generic-amd64.qcow2 \
  --cloud-init user-data=./cloud-init.cfg,disable=on \
  --network network=default \
  --osinfo=debian12 \
  --graphics none \
  --noautoconsole

rm cloud-init.cfg