#
# STILL IN BETA.
# NOT INTENDED TO BE USED IN A PRODUCTION.
# USE AT YOUR OWN RISK.
#


DOCKER_IMAGE_BUILDER = finx-builder:latest
DOCKER_IMAGE_AIRFLOW = finx-airflow:latest
MOUNT_DAGS_FOLDER = --mount type=bind,source="$$(pwd)"/dags,target=/opt/airflow/dags,readonly
MOUNT_LOGS_FOLDER = --mount type=bind,source="$$(pwd)"/logs,target=/opt/airflow/logs
DOCKER_PORT = -p 8080:8080
DOCKER_ENV_FILE = --env-file docker-env-file

docker.build.builder:
	docker build \
		-f Dockerfile --target builder --tag ${DOCKER_IMAGE_BUILDER} .


docker.build.airflow:
	docker build \
		-f Dockerfile --target airflow --tag ${DOCKER_IMAGE_AIRFLOW} .


docker.run.webserver:
	docker run \
		-it \
		${DOCKER_ENV_FILE} \
		${DOCKER_PORT} \
		${MOUNT_DAGS_FOLDER} \
		${MOUNT_LOGS_FOLDER} \
		${DOCKER_IMAGE_AIRFLOW} \
		webserver

docker.run.webserver:
	docker run \
		-it \
		${DOCKER_ENV_FILE} \
		${MOUNT_DAGS_FOLDER} \
		${MOUNT_LOGS_FOLDER} \
		${DOCKER_IMAGE_AIRFLOW} \
		scheduler

docker.run.bash:
	docker run \
		-it \
		--entrypoint /bin/bash \
		${DOCKER_ENV_FILE} \
		${MOUNT_DAGS_FOLDER} \
		${MOUNT_LOGS_FOLDER} \
		${DOCKER_IMAGE_AIRFLOW}
