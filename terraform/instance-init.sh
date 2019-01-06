#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

curl -fsSL get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
sudo usermod -aG docker ubuntu
sudo docker pull concourse/dev &
