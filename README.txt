1. Preparing a local test bed:

	docker-compose

		diff --git a/docker-compose.yml b/docker-compose.yml
		index 1b7dc7b03..a79b989a9 100644
		--- a/docker-compose.yml
		+++ b/docker-compose.yml
		@@ -29,6 +29,18 @@ services:
		     - CONCOURSE_MAIN_TEAM_LOCAL_USER=test
		     - CONCOURSE_LOG_LEVEL=debug

		+  minio:
		+    container_name: minio
		+    image: minio/minio
		+    environment:
		+      MINIO_ACCESS_KEY: testtest
		+      MINIO_SECRET_KEY: testtest
		+      MINIO_REGION: us-east-1
		+    ports:
		+    - 9000:9000
		+    command: [ 'server', '/data' ]
		+
		+
		   worker:
		     build:
		       context: .


	pipeline.yml

		resource_types:
		- name: s3
		  type: registry-image
		  source:
		    repository: concourse/s3-resource

		resources:
		- name: release
		  type: s3
		  source:
		    access_key_id: testtest
		    bucket: releases
		    disable_ssl: true
		    endpoint: http://minio:9000
		    initial_path: binary-1.0.0.tgz
		    regexp: binary-(.*).tgz
		    secret_access_key: testtest
		    skip_download: true

		- name: busybox
		  type: registry-image
		  source:
		    repository: busybox

		jobs:
		- name: mything
		  plan:
		  - aggregate:
		    - get: busybox
		      trigger: true
		  - task: create-file
		    image: busybox
		    config:
		      platform: linux
		      outputs:
		      - name: releases
			path: .
		      run:
			path: /bin/sh
			args:
			- -ce
			- |
			  echo "stuff" > ./binary-1.0.0.tgz

		  - put: release
		    params:
		      file: ./releases/binary-*.tgz


2. Running it on EC2
	
	terraform:
		- configure a bucket
		- create an instance w/ instance profile that allows pushing to that bucket
		- run concourse on it (local dev should be fine)
	manually:
		- set the pipeline above w/out tweaking the endpoint
		- check that it runs successfully


