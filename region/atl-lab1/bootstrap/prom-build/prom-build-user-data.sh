#!/bin/bash

apt-get update -y

apt-get install -y docker.io curl ipmitool make
adduser ubuntu docker

apt-get install -y default-jre-headless
