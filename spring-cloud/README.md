# Spring Cloud - PetClinic Application 


## 기술 구성

Category | Spring Cloud Petclinic
---------|---------
Spring stack	|	Spring Cloud
Architecture	|	Microservices
Persistence	|	Spring Data JPA
View	|	AngularJS
Databases support	|	HSQLDB, MySQL


&nbsp;
## 구성요소

Spring Cloud components|URL & Port
-----|------
Config Server | http://localhost:8888
Discovery Server | http://localhost:8761
AngularJS frontend (API Gateway) | http://localhost:8080
Customers, Vets and Visits Services | random port, check Eureka Dashboard
Tracing Server (Zipkin) | http://localhost:9411
Admin Server (Spring Boot Admin) | http://localhost:9090


&nbsp;
### Step 1: 실습용 쉘 스크립트 다운로드

	# git clone https://github.com/kmsandbox/petclinic-on-kubernetes.git
	# cd spring-cloud


&nbsp;
### Step 2: 마이그레이션 대상 애플리케이션의 도커 이미지 빌드

#### A. 샘플 애플리케이션 소스 다운로드 (spring-cloud/clone-petclinic-microservices.sh)

	# git clone https://github.com/spring-petclinic/spring-petclinic-microservices.git


#### B. 픽스 적용 : 의존성 정보 추가 (spring-cloud/apply-fixes.sh)

일부 서비스들의 pom.xml에서 codehaus stax2-api에 대한 의존성 정보가 빠져있습니다.

	<dependency>
	   <groupId>org.codehaus.woodstox</groupId>
	   <artifactId>stax2-api</artifactId>
	   <version>3.1.1</version>
	</dependency>

아래 명령어를 실행해 의존성 정보를 추가합니다.

	# cp fixes/customers-pom.xml spring-petclinic-microservices/spring-petclinic-customers-service/pom.xml
	# cp fixes/visits-pom.xml spring-petclinic-microservices/spring-petclinic-visits-service/pom.xml
	# cp fixes/vets-pom.xml spring-petclinic-microservices/spring-petclinic-vets-service/pom.xml


#### C. 도커 이미지 빌드 (spring-cloud/build-docker-images.sh)

	# cd spring-petclinic-microservices
	# mvn clean install -PbuildDocker


#### D. 도커 이미지 확인 

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



&nbsp;
### Step 3: 도커 컨테이너 실행 및 애플리케이션 서비스 동작 확인

#### A. 컨테이너 실행 (spring-cloud/test-local-docker-1.sh)

	# cd spring-petclinic-microservices
	# docker-compose up 
	

docker-compose up으로 서비스가 잘 시작되지 않는다면 아래 명령어를 순차적으로 실행시켜 다시 시도합니다.

* spring-cloud/test-local-docker-2.sh
	
	# docker-compose up config-server &
	# sleep 60s
	# docker-compose up discovery-server &
	# sleep 60s
	# docker-compose up customers-service &
	# sleep 10s
	# docker-compose up vets-service &
	# sleep 10s
	# docker-compose up visits-service &
	# sleep 10s
	# docker-compose up api-gateway &
	# sleep 10s
	# docker-compose up admin-server &
	# sleep 10s
	# docker-compose up tracing-server &

#### B. 컨테이너 목록 확인

	# docker ps | grep spring-petclinic
	
#### C. 접속 확인

	# curl http://localhost:8761
	# curl http://localhost:8888
	# curl http://localhost:8080
	# curl http://localhost:9411
	# curl http://localhost:9090
	
#### D. 컨테이너 제거

	# cd spring-petclinic-microservices
	# docker-compose down
	

&nbsp;
### Step 4: IBM Cloud Private - Private Docker Registry에 이미지 등록하기

#### A. 이미지 이름 변경 (spring-cloud/retag-image.sh)

	# docker tag mszarlinski/spring-petclinic-tracing-server:latest stdcluster.icp:8500/default/spring-petclinic-tracing-server:latest
	# docker tag mszarlinski/spring-petclinic-api-gateway:latest stdcluster.icp:8500/default/spring-petclinic-api-gateway:latest
	# docker tag mszarlinski/spring-petclinic-discovery-server:latest stdcluster.icp:8500/default/spring-petclinic-discovery-server:latest
	# docker tag mszarlinski/spring-petclinic-config-server:latest stdcluster.icp:8500/default/spring-petclinic-config-server:latest
	# docker tag mszarlinski/spring-petclinic-visits-service:latest stdcluster.icp:8500/default/spring-petclinic-visits-service:latest
	# docker tag mszarlinski/spring-petclinic-vets-service:latest stdcluster.icp:8500/default/spring-petclinic-vets-service:latest
	# docker tag mszarlinski/spring-petclinic-customers-service:latest stdcluster.icp:8500/default/spring-petclinic-customers-service:latest
	# docker tag mszarlinski/spring-petclinic-admin-server:latest stdcluster.icp:8500/default/spring-petclinic-admin-server:latest

#### B. 이미지 이름 확인 
	
	# docker images | grep spring-petclinic
	
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
	

#### C. ICP Private Docker Registry에 로그인

***확인 필요 : 로컬에서 ICP Private Docker Registry 에 연결하는 방법  ***

	# docker login stdcluster.icp:8500

#### D. ICP Private Docker Registry에 이미지 등록 (spring-cloud/push-image.sh)

	# docker push stdcluster.icp:8500/default/spring-petclinic-config-server:latest
	# docker push stdcluster.icp:8500/default/spring-petclinic-discovery-server:latest
	# docker push stdcluster.icp:8500/default/spring-petclinic-customers-service:latest
	# docker push stdcluster.icp:8500/default/spring-petclinic-vets-service:latest
	# docker push stdcluster.icp:8500/default/spring-petclinic-visits-service:latest
	# docker push stdcluster.icp:8500/default/spring-petclinic-api-gateway:latest
	# docker push stdcluster.icp:8500/default/spring-petclinic-admin-server:latest
	# docker push stdcluster.icp:8500/default/spring-petclinic-tracing-server:latest
	
#### E. ICP UI에서 등록된 이미지 목록 확인


&nbsp;
### Step 5. IBM Cloud Private에 샘플 애플리케이션 배포하기

#### A. Kompose로 docker-compose.yml을 변환해 Kubernetes용 yaml 만들기

Kompose는 Compose 포맷 YAML 파일을 Kubernetes 포맷으로 변경해주는 툴입니다. 아래 명령어를 실행하면 각 애플리케이션 서비스에 대해 Service와 Deployment 객체가 만들어 집니다.

	# cd yaml4kube
	# cp ../spring-petclinic-microservices/docker-compose.yml .
	# kompose convert -f docker-compose.yml

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

#### B. 생성된 yaml에서 image와 command-arg 수정 (spring-cloud/replace-imagenames-in-yaml.sh)

	# cd ..
	# cp -rf yaml4kube yaml4kube-new
	# cd yaml4kube-new
	# echo "sed -i 's/mszarlinski/stdcluster.icp:8500\/default/g' *deployment.yaml"
	# sed -i 's/mszarlinski/default/g' *deployment.yaml
	# cat customers-service-deployment.yaml
	# cat customers-service-service.yaml

#### C. ICP Docker Registry에 image push (spring-cloud/push-images.sh)

	# docker push stdcluster.icp:8500/default/spring-petclinic-config-server:latest
	# docker push stdcluster.icp:8500/default/spring-petclinic-discovery-server:latest
	# docker push stdcluster.icp:8500/default/spring-petclinic-visits-service:latest
	# docker push stdcluster.icp:8500/default/spring-petclinic-vets-service:latest
	# docker push stdcluster.icp:8500/default/spring-petclinic-customers-service:latest
	# docker push stdcluster.icp:8500/default/spring-petclinic-api-gateway:latest
	# docker push stdcluster.icp:8500/default/spring-petclinic-tracing-server:latest
	# docker push stdcluster.icp:8500/default/spring-petclinic-admin-server:latest

#### C. 샘플 애플리케이션 객체 배포 (spring-cloud/kube-apply.sh)

	# kubectl apply -f yaml4kube-new/config-server-service.yaml
	# kubectl apply -f yaml4kube-new/config-server-deployment.yaml
	# sleep 10s
	# kubectl apply -f yaml4kube-new/discovery-server-deployment.yaml
	# kubectl apply -f yaml4kube-new/discovery-server-service.yaml
	# sleep 10s
	# kubectl apply -f yaml4kube-new/customers-service-deployment.yaml
	# kubectl apply -f yaml4kube-new/customers-service-service.yaml
	# sleep 3s
	# kubectl apply -f yaml4kube-new/vets-service-deployment.yaml
	# kubectl apply -f yaml4kube-new/vets-service-service.yaml
	# sleep 3s
	# kubectl apply -f yaml4kube-new/visits-service-deployment.yaml
	# kubectl apply -f yaml4kube-new/visits-service-service.yaml
	# sleep 3s
	# kubectl apply -f yaml4kube-new/api-gateway-service.yaml
	# kubectl apply -f yaml4kube-new/api-gateway-deployment.yaml
	# sleep 3s
	# kubectl apply -f yaml4kube-new/tracing-server-service.yaml
	# kubectl apply -f yaml4kube-new/tracing-server-deployment.yaml
	# sleep 3s
	# kubectl apply -f yaml4kube-new/admin-server-deployment.yaml
	# kubectl apply -f yaml4kube-new/admin-server-service.yaml		

	# kubectl get deployment,svc,pods,pvc	


#### D. 배포 결과 확인

	# kubectl get deploy,svc
	
	# curl http://<Proxy_IP>:<NodePort>

#### E. 샘플 애플리케이션 객체 제거  (spring-cloud/kube-delete.sh)

	# kubectl delete -f yaml4kube-new/config-server-service.yaml	
	# kubectl delete -f yaml4kube-new/config-server-deployment.yaml	
	# kubectl delete -f yaml4kube-new/discovery-server-deployment.yaml	
	# kubectl delete -f yaml4kube-new/discovery-server-service.yaml	
	# kubectl delete -f yaml4kube-new/customers-service-deployment.yaml	
	# kubectl delete -f yaml4kube-new/customers-service-service.yaml		
	# kubectl delete -f yaml4kube-new/vets-service-deployment.yaml
	# kubectl delete -f yaml4kube-new/vets-service-service.yaml		
	# kubectl delete -f yaml4kube-new/visits-service-deployment.yaml
	# kubectl delete -f yaml4kube-new/visits-service-service.yaml	
	# kubectl delete -f yaml4kube-new/api-gateway-service.yaml	
	# kubectl delete -f yaml4kube-new/api-gateway-deployment.yaml		
	# kubectl delete -f yaml4kube-new/tracing-server-service.yaml
	# kubectl delete -f yaml4kube-new/tracing-server-deployment.yaml
	# kubectl delete -f yaml4kube-new/admin-server-deployment.yaml	
	# kubectl delete -f yaml4kube-new/admin-server-service.yaml

	# kubectl get deployment,svc,pods,pvc
