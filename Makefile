#
# STILL IN BETA.
# NOT INTENDED FOR PRODUCTION USE.
# USE AT YOUR OWN RISK.
#

DOCKER_IMAGE_BUILDER = finx-builder:latest
DOCKER_IMAGE_AIRFLOW = finx-airflow:latest

# docker.build: docker.build.__base
build:
	docker build \
		-f Dockerfile \
		--tag ${DOCKER_IMAGE_AIRFLOW} \
		.

changelog:
	git-chglog -o CHANGELOG.md


airflow.bash:
	docker-compose run --entrypoint /bin/bash webserver
	
airflow.up:
	docker-compose up -d webserver scheduler

airflow.stop:
	docker-compose stop webserver scheduler
