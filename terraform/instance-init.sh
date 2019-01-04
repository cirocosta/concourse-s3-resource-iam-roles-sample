#!/bin/bash

set -o errexit
set -o nounset

main() {
	install_docker
	prepare_worker
}

install_docker() {
	echo "INFO: Installing docker"

	curl -fsSL get.docker.com -o get-docker.sh
	sudo sh ./get-docker.sh
	sudo usermod -aG docker ubuntu
}

prepate_worker() {
	docker pull concourse/concourse:dev
}

main
