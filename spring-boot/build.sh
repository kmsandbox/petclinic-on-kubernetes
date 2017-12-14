#!/usr/bin/env bash
if [ $# -eq 0 ]
  then 
    tag='latest'
  else
    tag=$1
fi

echo "
docker build --build-arg url=https://github.com/spring-projects/spring-petclinic.git\
  --build-arg project=spring-petclinic\
  --build-arg artifactid=spring-petclinic\
  --build-arg version=1.5.1\
  -t nfrankel/spring-petclinic - < Dockerfile
"

docker build --build-arg url=https://github.com/spring-projects/spring-petclinic.git\
  --build-arg project=spring-petclinic\
  --build-arg artifactid=spring-petclinic\
  --build-arg version=1.5.1\
  -t nfrankel/spring-petclinic - < Dockerfile
