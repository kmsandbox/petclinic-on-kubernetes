# 스프링 클라우드 - 펫클리닉 애플리케이션 

## technology stack

Category | Spring Cloud Petclinic
---------|---------
Spring stack	|	Spring Cloud
Architecture	|	Microservices
Persistence	|	Spring Data JPA
View	|	AngularJS
Databases support	|	HSQLDB, MySQL

## 구성요소

Spring Cloud components|URL & Port
-----|------
Discovery Server | http://localhost:8761
Config Server | http://localhost:8888
AngularJS frontend (API Gateway) | http://localhost:8080
Customers, Vets and Visits Services | random port, check Eureka Dashboard
Tracing Server (Zipkin) | http://localhost:9411
Admin Server (Spring Boot Admin) | http://localhost:9090



### Step 1: 마이그레이션 대상 애플리케이션 - 도커 이미지 빌드

#### A. 코드 : get-petclinic-microservices.sh 

	git clone https://github.com/spring-petclinic/spring-petclinic-microservices.git

#### B. 픽스 적용 : apply-fixes.sh 

* 의존성 정보 추가

	cp fixes/customers-pom.xml spring-petclinic-microservices/spring-petclinic-customers-service/pom.xml
	cp fixes/visits-pom.xml spring-petclinic-microservices/spring-petclinic-visits-service/pom.xml
	cp fixes/vets-pom.xml spring-petclinic-microservices/spring-petclinic-vets-service/pom.xml

#### C. 도커 이미지 빌드 : build-docker-images.sh 

	cd spring-petclinic-microservices
	mvn clean install -PbuildDocker

#### D. 도커 이미지 확인 : 

	# docker images
	
	REPOSITORY                                       TAG                 IMAGE ID            CREATED             SIZE
	mszarlinski/spring-petclinic-tracing-server      latest              bb8098454217        13 minutes ago      720MB
	mszarlinski/spring-petclinic-api-gateway         latest              a962c2f00daf        13 minutes ago      738MB
	mszarlinski/spring-petclinic-discovery-server    latest              ae078e75062a        15 minutes ago      723MB
	mszarlinski/spring-petclinic-config-server       latest              03be666972d3        16 minutes ago      691MB
	mszarlinski/spring-petclinic-visits-service      latest              f3e239937900        16 minutes ago      750MB
	mszarlinski/spring-petclinic-vets-service        latest              affd2d4535a3        17 minutes ago      754MB
	mszarlinski/spring-petclinic-customers-service   latest              7379b79a3631        17 minutes ago      750MB
	mszarlinski/spring-petclinic-admin-server        latest              968f24280672        18 minutes ago      719MB



### Step 2: 로컬 도커엔진에 이미지 배포해 컨테이너 동작 확인

#### A. 이미지를 로컬 도커에 배포 : docker-compose 

	cd spring-petclinic-microservices
	docker-compose up 
	
	or 
	
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

#### B. 도커 컨테이너 목록 확인

	docker ps | grep spring-petclinic
	
#### C. 접속 확인

	curl http://localhost:8761
	curl http://localhost:8888
	curl http://localhost:8080
	curl http://localhost:9411
	curl http://localhost:9090
	
#### D. 컨테이너 제거

	cd spring-petclinic-microservices
	docker-compose down
	

### Step 4: push docker image to Kubernetes - minikube or ICP 

#### A. retag the image

	# docker tag <source-namespace>/<image_name>:<tag>  <target-namespace>/<image_name>:<tag>  
	docker tag mszarlinski/spring-petclinic-tracing-server:latest stdcluster.icp:8500/default/spring-petclinic-tracing-server:latest
	docker tag mszarlinski/spring-petclinic-api-gateway:latest stdcluster.icp:8500/default/spring-petclinic-api-gateway:latest
	docker tag mszarlinski/spring-petclinic-discovery-server:latest stdcluster.icp:8500/default/spring-petclinic-discovery-server:latest
	docker tag mszarlinski/spring-petclinic-config-server:latest stdcluster.icp:8500/default/spring-petclinic-config-server:latest
	docker tag mszarlinski/spring-petclinic-visits-service:latest stdcluster.icp:8500/default/spring-petclinic-visits-service:latest
	docker tag mszarlinski/spring-petclinic-vets-service:latest stdcluster.icp:8500/default/spring-petclinic-vets-service:latest
	docker tag mszarlinski/spring-petclinic-customers-service:latest stdcluster.icp:8500/default/spring-petclinic-customers-service:latest
	docker tag mszarlinski/spring-petclinic-admin-server:latest stdcluster.icp:8500/default/spring-petclinic-admin-server:latest

#### B. Verify 
	
	docker images | grep spring-petclinic
	
	mszarlinski/spring-petclinic-tracing-server                      latest              bb8098454217        3 hours ago         720MB
	stdcluster.icp:8500/default/spring-petclinic-tracing-server      latest              bb8098454217        3 hours ago         720MB
	mszarlinski/spring-petclinic-api-gateway                         latest              a962c2f00daf        3 hours ago         738MB
	stdcluster.icp:8500/default/spring-petclinic-api-gateway         latest              a962c2f00daf        3 hours ago         738MB
	mszarlinski/spring-petclinic-discovery-server                    latest              ae078e75062a        3 hours ago         723MB
	stdcluster.icp:8500/default/spring-petclinic-discovery-server    latest              ae078e75062a        3 hours ago         723MB
	mszarlinski/spring-petclinic-config-server                       latest              03be666972d3        3 hours ago         691MB
	stdcluster.icp:8500/default/spring-petclinic-config-server       latest              03be666972d3        3 hours ago         691MB
	mszarlinski/spring-petclinic-visits-service                      latest              f3e239937900        3 hours ago         750MB
	stdcluster.icp:8500/default/spring-petclinic-visits-service      latest              f3e239937900        3 hours ago         750MB
	mszarlinski/spring-petclinic-vets-service                        latest              affd2d4535a3        3 hours ago         754MB
	stdcluster.icp:8500/default/spring-petclinic-vets-service        latest              affd2d4535a3        3 hours ago         754MB
	mszarlinski/spring-petclinic-customers-service                   latest              7379b79a3631        3 hours ago         750MB
	stdcluster.icp:8500/default/spring-petclinic-customers-service   latest              7379b79a3631        3 hours ago         750MB
	mszarlinski/spring-petclinic-admin-server                        latest              968f24280672        3 hours ago         719MB
	stdcluster.icp:8500/default/spring-petclinic-admin-server        latest              968f24280672        3 hours ago         719MB
	
#### C. Login to target docker registry
	
***확인 필요 : 로컬에서 ICP Private Docker Registry 에 연결하는 방법  ***

	docker login stdcluster.icp:8500

#### D. Push image

	docker push stdcluster.icp:8500/default/spring-petclinic-config-server:latest
	docker push stdcluster.icp:8500/default/spring-petclinic-discovery-server:latest
	docker push stdcluster.icp:8500/default/spring-petclinic-customers-service:latest
	docker push stdcluster.icp:8500/default/spring-petclinic-vets-service:latest
	docker push stdcluster.icp:8500/default/spring-petclinic-visits-service:latest
	docker push stdcluster.icp:8500/default/spring-petclinic-api-gateway:latest
	docker push stdcluster.icp:8500/default/spring-petclinic-admin-server:latest
	docker push stdcluster.icp:8500/default/spring-petclinic-tracing-server:latest
	
### Step 5. apply deployment 

#### A. Kompose로 docker-compose.yml을 변환해 Kubernetes용 yaml 만들기

	cd yaml4kube
	cp ../spring-petclinic-microservices/docker-compose.yml .
	kompose convert -f docker-compose.yml

	# 실행결과
		WARN Unsupported depends_on key - ignoring        
		INFO Kubernetes file "admin-server-service.yaml" created 
		INFO Kubernetes file "api-gateway-service.yaml" created 
		INFO Kubernetes file "config-server-service.yaml" created 
		INFO Kubernetes file "customers-service-service.yaml" created 
		INFO Kubernetes file "discovery-server-service.yaml" created 
		INFO Kubernetes file "tracing-server-service.yaml" created 
		INFO Kubernetes file "vets-service-service.yaml" created 
		INFO Kubernetes file "visits-service-service.yaml" created 
		INFO Kubernetes file "admin-server-deployment.yaml" created 
		INFO Kubernetes file "api-gateway-deployment.yaml" created 
		INFO Kubernetes file "config-server-deployment.yaml" created 
		INFO Kubernetes file "customers-service-deployment.yaml" created 
		INFO Kubernetes file "discovery-server-deployment.yaml" created 
		INFO Kubernetes file "tracing-server-deployment.yaml" created 
		INFO Kubernetes file "vets-service-deployment.yaml" created 
		INFO Kubernetes file "visits-service-deployment.yaml" created 

#### B. 생성된 yaml에서 image와 command-arg 수정

	cd ..
	./replace-imagenames-in-yaml.sh
	
	# replace-imagenames-in-yaml.sh 내용
		
		cp -rf yaml4kube yaml4kube-new
		cd yaml4kube-new
		echo "sed -i 's/mszarlinski/stdcluster.icp:8500\/default/g' *deployment.yaml"
		echo
		sed -i 's/mszarlinski/default/g' *deployment.yaml
		echo "current path: "
		pwd
		echo ""
		ls
		echo ""
		echo ""
		cat customers-service-deployment.yaml
		echo ""
		cat customers-service-service.yaml

#### C. ICP Docker Registry에 image push

	./push-images.sh 
		
	# push-images.sh 내용
		docker push stdcluster.icp:8500/default/spring-petclinic-tracing-server:latest
		docker push stdcluster.icp:8500/default/spring-petclinic-api-gateway:latest
		docker push stdcluster.icp:8500/default/spring-petclinic-discovery-server:latest
		docker push stdcluster.icp:8500/default/spring-petclinic-config-server:latest
		docker push stdcluster.icp:8500/default/spring-petclinic-visits-service:latest
		docker push stdcluster.icp:8500/default/spring-petclinic-vets-service:latest
		docker push stdcluster.icp:8500/default/spring-petclinic-customers-service:latest
		docker push stdcluster.icp:8500/default/spring-petclinic-admin-server:latest

#### D. Image push

	./push-images.sh

	# push-images.sh 내용
		docker push stdcluster.icp:8500/default/spring-petclinic-tracing-server:latest
		docker push stdcluster.icp:8500/default/spring-petclinic-api-gateway:latest
		docker push stdcluster.icp:8500/default/spring-petclinic-discovery-server:latest
		docker push stdcluster.icp:8500/default/spring-petclinic-config-server:latest
		docker push stdcluster.icp:8500/default/spring-petclinic-visits-service:latest
		docker push stdcluster.icp:8500/default/spring-petclinic-vets-service:latest
		docker push stdcluster.icp:8500/default/spring-petclinic-customers-service:latest
		docker push stdcluster.icp:8500/default/spring-petclinic-admin-server:latest

#### E. Deploy

	./kube-apply.sh
	
	# kube-apply.sh 내용
		kubectl apply -f yaml4kube-new/config-server-service.yaml
		kubectl apply -f yaml4kube-new/config-server-deployment.yaml
		sleep 10s
		kubectl apply -f yaml4kube-new/discovery-server-deployment.yaml
		kubectl apply -f yaml4kube-new/discovery-server-service.yaml
		sleep 10s
		kubectl apply -f yaml4kube-new/customers-service-deployment.yaml
		kubectl apply -f yaml4kube-new/customers-service-service.yaml
		sleep 3s
		kubectl apply -f yaml4kube-new/vets-service-deployment.yaml
		kubectl apply -f yaml4kube-new/vets-service-service.yaml
		sleep 3s
		kubectl apply -f yaml4kube-new/visits-service-deployment.yaml
		kubectl apply -f yaml4kube-new/visits-service-service.yaml
		sleep 3s
		kubectl apply -f yaml4kube-new/api-gateway-service.yaml
		kubectl apply -f yaml4kube-new/api-gateway-deployment.yaml
		sleep 3s
		kubectl apply -f yaml4kube-new/tracing-server-service.yaml
		kubectl apply -f yaml4kube-new/tracing-server-deployment.yaml
		sleep 3s
		kubectl apply -f yaml4kube-new/admin-server-deployment.yaml
		kubectl apply -f yaml4kube-new/admin-server-service.yaml			
		kubectl get deployment,svc,pods,pvc	

#### F. check

	kubectl get deploy,svc
	
	curl http://10.10.16.48:32048

#### G. delete

	./kube-delete.sh
