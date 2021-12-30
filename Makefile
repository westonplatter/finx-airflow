#
# STILL IN BETA.
# NOT INTENDED TO BE USED IN A PRODUCTION.
# USE AT YOUR OWN RISK.
#

DOCKER_IMAGE_AIRFLOW = finx-airflow:latest
MOUNT_DAGS_FOLDER = --mount type=bind,source="$$(pwd)"/dags,target=/opt/airflow/dags,readonly
MOUNT_LOGS_FOLDER = --mount type=bind,source="$$(pwd)"/logs,target=/opt/airflow/logs,readonly


docker.build.builder:
	docker build -f Dockerfile --target builder --tag finx-builder .


docker.build.airflow:
	docker build -f Dockerfile --target airflow --tag ${DOCKER_IMAGE_AIRFLOW} .


docker.run.webserver:
	docker run \
		-it \
		--env-file docker-env-file \
		--port 8080:8080 \
		${MOUNT_DAGS_FOLDER} \
		${MOUNT_LOGS_FOLDER} \
		${DOCKER_IMAGE_AIRFLOW} \
		webserver
