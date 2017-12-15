#!/usr/bin/env bash
  
# docker tag <source-namespace>/<image_name>:<tag>  <target-namespace>/<image_name>:<tag>  

docker tag local-docker/spring-framework-petclinic:latest stdcluster.icp:8500/default/spring-framework-petclinic:latest
