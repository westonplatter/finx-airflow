# Finx Airflow
A keep it simple/stupid dockerize airflow.

## Example

## How to get started

Build the image,

    ```sh
    make docker.build
    ```

Test that the DB connection works, 

    ```sh
    docker-compose run airflow-cli db check
    ```

Initialize the DB,

    ```sh
    docker-compose run airflow-cli db init
    ```


Run both the webserver and scheduler,

    ```sh
    docker-compose up
    ```

## Install
To get up and running,
- make
- docker
- docker-compose

The changelog tool in use (https://github.com/git-chglog/git-chglog) can be used as a binary.