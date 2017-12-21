#!/usr/bin/env bash

docker push mycluster.icp:8500/default/spring-petclinic-tracing-server:latest
docker push mycluster.icp:8500/default/spring-petclinic-api-gateway:latest
docker push mycluster.icp:8500/default/spring-petclinic-discovery-server:latest
docker push mycluster.icp:8500/default/spring-petclinic-config-server:latest
docker push mycluster.icp:8500/default/spring-petclinic-visits-service:latest
docker push mycluster.icp:8500/default/spring-petclinic-vets-service:latest
docker push mycluster.icp:8500/default/spring-petclinic-customers-service:latest
docker push mycluster.icp:8500/default/spring-petclinic-admin-server:latest

