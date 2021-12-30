
docker.build.builder:
	docker build -f Dockerfile --target builder --tag finx-builder .

docker.build.airflow:
	docker build -f Dockerfile --target airflow --tag finx-airflow .


docker.run.airflow:
	docker run -it finx-airflow /bin/bash
