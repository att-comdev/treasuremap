#!/bin/bash
set -ex
apt-get update -y
apt-get install -y default-jre-headless ntpdate jq

# setup hostname
echo '10.24.20.100 genesis' >> /etc/hosts
echo genesis >> /etc/hostname
hostname genesis

