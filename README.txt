RUNNING

	1.	Gather hush-house's worker private key
		and put it under ./terraform/keys/worker-private-key

	2.	Provision the AWS infrastructure

			cd ./terraform && \
				terraform apply -auto-approve

	3.	Run the worker process in it

			cd ./terraform && \
				make run-worker

	4.	Trigger the `release` job

			https://hush-house.concourse-ci.org/teams/main/pipelines/test-s3-resource/jobs/release/builds/10

