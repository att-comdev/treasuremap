#!/bin/bash

apt-get update -y
apt-get install -y default-jre-headless ntpdate

# setup hostname
echo '10.24.20.100 genesis' >> /etc/hosts
echo genesis >> /etc/hostname
hostname genesis

sudo  curl -L --insecure -o /usr/local/share/ca-certificates/gd_bundle-g2.crt https://certs.godaddy.com/repository/gd_bundle-g2.crt
sudo update-ca-certificates

