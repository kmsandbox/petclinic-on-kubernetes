#!/usr/bin/env bash
  
docker rmi stdcluster.icp:8500/default/spring-petclinic-tracing-server
docker rmi stdcluster.icp:8500/default/spring-petclinic-api-gateway
docker rmi stdcluster.icp:8500/default/spring-petclinic-discovery-server
docker rmi stdcluster.icp:8500/default/spring-petclinic-config-server
docker rmi stdcluster.icp:8500/default/spring-petclinic-visits-service
docker rmi stdcluster.icp:8500/default/spring-petclinic-vets-service
docker rmi stdcluster.icp:8500/default/spring-petclinic-customers-service
docker rmi stdcluster.icp:8500/default/spring-petclinic-admin-server

docker images | grep spring
