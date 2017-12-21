#!/usr/bin/env bash
  
docker tag mszarlinski/spring-petclinic-tracing-server:latest mycluster.icp:8500/default/spring-petclinic-tracing-server:latest
docker tag mszarlinski/spring-petclinic-api-gateway:latest mycluster.icp:8500/default/spring-petclinic-api-gateway:latest
docker tag mszarlinski/spring-petclinic-discovery-server:latest mycluster.icp:8500/default/spring-petclinic-discovery-server:latest
docker tag mszarlinski/spring-petclinic-config-server:latest mycluster.icp:8500/default/spring-petclinic-config-server:latest
docker tag mszarlinski/spring-petclinic-visits-service:latest mycluster.icp:8500/default/spring-petclinic-visits-service:latest
docker tag mszarlinski/spring-petclinic-vets-service:latest mycluster.icp:8500/default/spring-petclinic-vets-service:latest
docker tag mszarlinski/spring-petclinic-customers-service:latest mycluster.icp:8500/default/spring-petclinic-customers-service:latest
docker tag mszarlinski/spring-petclinic-admin-server:latest mycluster.icp:8500/default/spring-petclinic-admin-server:latest

docker images | grep petclinic
