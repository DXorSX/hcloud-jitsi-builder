#!/bin/bash

docker volume create --name=influxdb-volume
docker volume create --name=grafana-volume
docker-compose up