# 스프링 프레임워크 - 펫클리닉 애플리케이션 

## 기술 구성

Category | Spring Framework Petclinic
---------|---------
Spring stack	|	Plain Spring Framework
Architecture	|	3 Layers
Persistence	|	JDBC, JPA, Spring Data JPA
View	|	JSP
Databases support	|	HSQLDB, MySQL, PostgreSQL
Containers support	|	Tomcat 7, 8 and Jetty 9
Java support	|	Java 7 and 8


&nbsp;
### Step 1: 실습용 쉘 스크립트 다운로드 

실습에 사용한 쉘 스크립트를 다운로드해 활용합니다.

	# git clone https://github.com/kmsandbox/petclinic-on-kubernetes.git
	# cd spring-framework


&nbsp;
### Step 2: 마이그레이션 대상 애플리케이션 - 로컬 테스트

#### A. 코드 

	git clone https://github.com/spring-petclinic/spring-framework-petclinic

#### B. 로컬 실행 

	cd spring-framework-petclinic
	./mvnw tomcat7:run-war

#### C. 애플리케이션 동작 확인

	curl http://localhost:9966/petclinic



&nbsp;
### Step 3: 컨테이너화 : 도커파일 작성

#### A. Dockerfile

	FROM alpine/git as clone
	ARG url
	WORKDIR /app
	RUN git clone ${url}
	
	FROM maven:3.5-jdk-8-alpine as build
	ARG project
	WORKDIR /app
	COPY --from=clone /app/${project} /app
	RUN mvn install
	
	FROM tomcat:8.0
	ARG artifactid
	ENV artifact ${artifactid}.war
	WORKDIR /usr/local/tomcat/webapps/
	COPY --from=build /app/target/${artifact} /usr/local/tomcat/webapps/
	EXPOSE 8080
	CMD ["catalina.sh", "run"]

#### B. Build.sh

	docker build --build-arg url=https://github.com/spring-petclinic/spring-framework-petclinic.git\
	  --build-arg project=spring-framework-petclinic\
	  --build-arg artifactid=petclinic\
	  -t local-docker/spring-framework-petclinic - < Dockerfile



#### C. docker image 확인

	docker images
	
	REPOSITORY		TAG		IMAGE ID		CREATED	SIZE
	local-docker/spring-framework-petclinic	latest	fc7db0ed5a6c	3 days ago	491MB


&nbsp;
### Step 4: 로컬 도커엔진에 이미지 배포해 컨테이너 동작 확인

#### A. 이미지를 로컬 도커에 배포 

	docker run -ti -p8080:8080 local-docker/spring-framework-petclinic

#### B. 도커 컨테이너 목록 확인

	docker ps | grep spring-framework-petclinic
	
#### C. 접속 확인

	curl http://localhost:8080/petclinic/

#### D. 컨테이너 제거

	docker stop <container_id>
	docker rm <container_id>
	
	docker container prune 


&nbsp;
### Step 5: push docker image to Kubernetes - minikube or ICP 

#### A. retag the image

	# docker tag <source-namespace>/<image_name>:<tag>  <target-namespace>/<image_name>:<tag>  
	docker tag local-docker/spring-framework-petclinic:latest stdcluster.icp:8500/default/spring-framework-petclinic:latest

#### B. Verify 
	
	docker images | grep spring-framework-petclinic
	local-docker/spring-framework-petclinic	latest	7b9b87c280af	3 days ago	491MB
	stdcluster.icp:8500/default/spring-framework-petclinic	latest	7b9b87c280af	3 days ago	491MB

#### C. Login to target docker registry
	
***확인 필요 : 로컬에서 ICP Private Docker Registry 에 연결하는 방법  ***

	docker login stdcluster.icp:8500

#### D. Push image

	docker push stdcluster.icp:8500/default/spring-framework-petclinic		


&nbsp;
### Step 6. apply deployment 

#### A. Deployment.yaml 작성

	apiVersion: v1
	kind: Service
	metadata:
	  name: sf-petclinic-service
	  labels:
	    app: sf-petclinic
	spec:
	  type: NodePort
	  ports:
	    - name: http
	      port: 8080
	      targetPort: 8080
	  selector:
	    app: sf-petclinic
	---
	apiVersion: extensions/v1beta1
	kind: Deployment
	metadata:
	  labels:
	    app: sf-petclinic
	  name: sf-petclinic
	spec:
	  replicas: 1
	  template:
	    metadata:
	      labels:
	        app: sf-petclinic
	    spec:
	      containers:
	      - image: stdcluster.icp:8500/default/spring-framework-petclinic
	        name: sf-petclinic
	        ports:
	        - containerPort: 8080
	          protocol: TCP


#### apply

	kubectl apply -f deployment.yaml

#### check

	kubectl get deploy,svc | grep petclinic
	
	curl http://10.10.16.48:31637/petclinic/

