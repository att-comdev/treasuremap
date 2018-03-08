#!/bin/bash

apt-get update -y
apt-get install -y default-jre-headless ntpdate

# setup hostname
echo '10.24.20.100 genesis' >> /etc/hosts
echo genesis >> /etc/hostname
hostname genesis
update_etc_interfaces() {
cat << EOF | sudo tee -a /etc/network/interfaces
iface ens3 inet dhcp
iface ens4 inet dhcp
iface ens5 inet dhcp
iface ens6 inet dhcp
iface ens7 inet dhcp
iface ens8 inet dhcp
EOF
}

sudo ifup ens4
sudo ifup ens5
sudo ifup ens6
sudo ifup ens7
sudo ifup ens8

