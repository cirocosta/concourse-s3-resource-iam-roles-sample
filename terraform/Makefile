AWS_IP=$(shell terraform output public-ip)

ssh:
	ssh -i ./keys/key.rsa ubuntu@$(AWS_IP)

run-worker:
	ssh -i ./keys/key.rsa ubuntu@$(AWS_IP) bash /tmp/run-worker.sh
