#!/usr/bin/env bash

docker-compose up config-server &
sleep 60s
docker-compose up discovery-server &
sleep 60s
docker-compose up customers-service &
sleep 10s
docker-compose up vets-service &
sleep 10s
docker-compose up visits-service &
sleep 10s
docker-compose up api-gateway &
sleep 10s
docker-compose up admin-server &
sleep 10s
docker-compose up tracing-server &