# Finx Airflow

## Example

## How to get started

```sh
make docker.build.airflow
```

```sh
make docker.run.bash

# within docker
airflow db init
```

In terminal 1,
```sh
make docker.run.webserver
```

In terminal 2,
```sh
make docker.run.scheduler
```
