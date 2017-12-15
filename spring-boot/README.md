# 스프링 부트 - 펫클리닉 애플리케이션 

## technology stack

Category | "Canonical" Spring Petclinic
---------|---------
Spring stack	|	Spring Boot
Architecture	|	Aggregate-oriented domain
Persistence	|	Spring Data JPA
View	|	Thymeleaf
Databases support	|	HSQLDB, MySQL
Containers support	|	Embbeded Tomcat and Jetty
Java support	|	Java 8
  


### Step 1: 마이그레이션 대상 애플리케이션 - 로컬 테스트

#### A. 코드 

	git clone https://github.com/spring-projects/spring-petclinic
	cd spring-petclinic

#### B. 로컬 실행 

	cd spring-petclinic
	./mvnw spring-boot:run

#### C. 애플리케이션 동작 확인

	curl http://localhost:8080/

### Step 2: 컨테이너화 : 도커파일 작성

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
	
	FROM openjdk:8-jre-alpine
	ARG artifactid
	ARG version
	ENV artifact ${artifactid}-${version}.jar
	WORKDIR /app
	COPY --from=build /app/target/${artifact} /app
	EXPOSE 8080
	ENTRYPOINT ["sh", "-c"]
	CMD ["java -jar ${artifact}"] 

#### B. Build.sh

	docker build --build-arg url=https://github.com/spring-projects/spring-petclinic.git\
	  --build-arg project=spring-petclinic\
	  --build-arg artifactid=spring-petclinic\
	  --build-arg version=1.5.1\
	  -t nfrankel/spring-petclinic - < Dockerfile

#### C. docker image 확인

	docker images
	
	REPOSITORY		TAG		IMAGE ID		CREATED		SIZE
	nfrankel/spring-petclinic	latest	447903f1397a	2 days ago	118MB


### Step 3: 로컬 도커엔진에 이미지 배포해 컨테이너 동작 확인

#### A. 이미지를 로컬 도커에 배포 

	docker run -ti -p8080:8080 nfrankel/spring-petclinic

#### B. 도커 컨테이너 목록 확인

	docker ps | grep spring-petclinic
	
#### C. 접속 확인

	curl http://localhost:8080/

#### D. 안쓰는 컨테이너 모두 제거

	docker container prune 

### Step 4: push docker image to Kubernetes - minikube or ICP 

#### A. retag the image

	# docker tag <source-namespace>/<image_name>:<tag>  <target-namespace>/<image_name>:<tag>  
	docker tag nfrankel/spring-petclinic:latest stdcluster.icp:8500/default/spring-petclinic:latest

#### B. Verify 
	
	docker images | grep petclinic
	nfrankel/spring-petclinic	latest	94f9a87f5f2c	2 days ago	118MB
	stdcluster.icp:8500/default/spring-petclinic	latest	94f9a87f5f2c	2 days ago	118MB

#### C. Login to target docker registry
	
***확인 필요 : 로컬에서 ICP Private Docker Registry 에 연결하는 방법  ***

	docker login stdcluster.icp:8500

#### D. Push image

	docker push stdcluster.icp:8500/default/spring-petclinic
		
### Step 5. apply deployment 

#### A. Deployment.yaml 작성

	apiVersion: v1
	kind: Service
	metadata:
	  name: sb-petclinic-service
	  labels:
	    app: sb-petclinic
	spec:
	  type: NodePort
	  ports:
	    - name: http
	      port: 8081
	      targetPort: 8080
	  selector:
	    app: sb-petclinic
	---
	apiVersion: extensions/v1beta1
	kind: Deployment
	metadata:
	  labels:
	    app: sb-petclinic
	  name: sb-petclinic
	spec:
	  replicas: 1
	  template:
	    metadata:
	      labels:
	        app: sb-petclinic
	    spec:
	      containers:
	      - image: stdcluster.icp:8500/default/spring-petclinic
	        name: sb-petclinic
	        ports:
	        - containerPort: 8080
	          protocol: TCP

#### apply

	kubectl apply -f deployment.yaml

#### 확인

	kubectl get deploy,svc | grep petclinic
	
	curl http://<proxy:ip>:31350
	
### Step 6. 제거
	
#### delete
	
	
	kubectl delete -f deployment.yaml
