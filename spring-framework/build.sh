#!/usr/bin/env bash

echo "
docker build --build-arg url=https://github.com/spring-petclinic/spring-framework-petclinic.git\
  --build-arg project=spring-framework-petclinic\
  --build-arg artifactid=petclinic\
  -t local-docker/spring-framework-petclinic - < Dockerfile
"

docker build --build-arg url=https://github.com/spring-petclinic/spring-framework-petclinic.git\
  --build-arg project=spring-framework-petclinic\
  --build-arg artifactid=petclinic\
  -t local-docker/spring-framework-petclinic - < Dockerfile

