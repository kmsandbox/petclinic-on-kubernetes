#!/usr/bin/env bash
  
docker rmi mycluster.icp:8500/default/spring-petclinic-tracing-server
docker rmi mycluster.icp:8500/default/spring-petclinic-api-gateway
docker rmi mycluster.icp:8500/default/spring-petclinic-discovery-server
docker rmi mycluster.icp:8500/default/spring-petclinic-config-server
docker rmi mycluster.icp:8500/default/spring-petclinic-visits-service
docker rmi mycluster.icp:8500/default/spring-petclinic-vets-service
docker rmi mycluster.icp:8500/default/spring-petclinic-customers-service
docker rmi mycluster.icp:8500/default/spring-petclinic-admin-server

docker images | grep spring
