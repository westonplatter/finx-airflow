#
# STILL IN BETA.
# NOT INTENDED FOR PRODUCTION USE.
# USE AT YOUR OWN RISK.
#

DOCKER_IMAGE_BUILDER = finx-builder:latest
DOCKER_IMAGE_AIRFLOW = finx-airflow:latest

# docker.build.__base:
# 	docker build \
# 		-f Dockerfile --target builder --tag ${DOCKER_IMAGE_BUILDER} .

# docker.build: docker.build.__base
docker.build:
	docker build -f Dockerfile --tag ${DOCKER_IMAGE_AIRFLOW} .



run.bash:
	docker-compose run --entrypoint /bin/bash airflow-webserver

changelog:
	git-chglog -o CHANGELOG.md
