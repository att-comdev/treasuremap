#!/bin/bash

apt-get update -y

apt-get install -y docker.io curl ipmitool make
adduser ubuntu docker

apt-get install -y default-jre-headless


curl -L --insecure -o /usr/local/share/ca-certificates/gd_bundle-g2.crt https://certs.godaddy.com/repository/gd_bundle-g2.crt
update-ca-certificates

apt-get install -y default-jre-headless
