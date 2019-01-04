#!/bin/bash

set -o errexit
set -o nounset


readonly TSA_HOST="hush-house.concourse-ci.org:2222"
readonly TSA_PUBLIC_KEY="/tsa-public-key"
readonly WORKER_PRIVATE_KEY="/worker-private-key"


docker run \
	--detach \
	--volume $TSA_PUBLIC_KEY:/tsa.pub \
	--volume $WORKER_PRIVATE_KEY:/worker.private \
	concourse/dev worker \
	--tag=aws \
	--ephemeral=true \
	--tsa-host=$TSA_HOST \
	--tsa-public-key=/tsa.pub \
	--tsa-worker-private-key=/worker.private
