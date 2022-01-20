#https://github.com/godatadriven-dockerhub/airflow
# copy this setup

FROM apache/airflow:2.1.2

USER root

#RUN apt-get update \
  #&& apt-get install -y --no-install-recommends \
         #build-essential libopenmpi-dev \
  #&& apt-get autoremove -yqq --purge \
  #&& apt-get clean \
  #&& rm -rf /var/lib/apt/lists/*
# RUN apt-get update

USER airflow

