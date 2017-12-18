# Spring Framework - PetClinic Application

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

	# git clone https://github.com/kmsandbox/petclinic-on-kubernetes.git
	# cd spring-framework


&nbsp;
### Step 2: 마이그레이션 대상 애플리케이션의 정상 동작 여부 확인

마이그레이션할 애플리케이션이 정상 동작하는지 확인합니다. 빌드나 실행에 문제가 있을 때는 반드시 해결하고 나서 다음 단계로 진행합니다.

#### A. 샘플 애플리케이션 소스 다운로드 (spring-framework/clone-petclinic.sh)

	# git clone https://github.com/spring-petclinic/spring-framework-petclinic

#### B. 빌드 및 실행

	# cd spring-framework-petclinic
	# ./mvnw tomcat7:run-war


#### C. 애플리케이션 서비스 정상 동작 확인 

	# curl http://localhost:9966/petclinic



&nbsp;
### Step 3: 샘플 애플리케이션과 실행 환경을 도커 이미지로 작성

#### A. Dockerfile  (cat spring-boot/Dockerfile)

도커성이미지를 만들기 위한 템플릿을 정의합니다. 이 Dockerfile에서는 3단계에 걸쳐 이미지를 생성하며 ${arg}는 docker build 명령어의 build-arg 인자로 받습니다.  
* 1단계 clone : 애플리케이션 소스를 컨테이너 내로 다운로드한 이미지를 생성합니다.
* 2단계 build : clone 컨테이너에 다운로드된 애플리케이션 코드를 maven으로 빌드해 패키지를 만듭니다.
* 3단계 target : build 컨테이너로부터 애플리케이션 패키지를 복사하고 서비스 포트를 지정한 다음 애플리케이션을 실행시킵니다.


```
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
```


#### B. 도커 이미지 빌드 (spring-framework/build.sh)

도커 이미지 이름은 -t 옵션으로 지정하고, Dockerfile에 기입된 내용으로 이미지를 빌드합니다.

	# docker build --build-arg url=https://github.com/spring-petclinic/spring-framework-petclinic.git\
	  --build-arg project=spring-framework-petclinic\
	  --build-arg artifactid=petclinic\
	  -t local-docker/spring-framework-petclinic - < Dockerfile



#### C. 도커 이미지 목록 확인 

	# docker images
	
	REPOSITORY		TAG		IMAGE ID		CREATED	SIZE
	local-docker/spring-framework-petclinic	latest	fc7db0ed5a6c	3 days ago	491MB


&nbsp;
### Step 4: 도커 컨테이너 실행 및 애플리케이션 서비스 동작 확인

#### A. 컨테이너 실행 (spring-framework/run.sh)

	# docker run -ti -p8080:8080 local-docker/spring-framework-petclinic

#### B. 컨테이너 목록 확인

	# docker ps | grep spring-framework-petclinic
	
#### C. 애플리케이션 서비스 정상 동작 확인 

	# curl http://localhost:8080/petclinic/

#### D. 컨테이너 제거

	# docker stop <container_id>
	# docker rm <container_id>
	

&nbsp;
### Step 5: IBM Cloud Private - Private Docker Registry에 이미지 등록하기

#### A. 이미지 이름 변경 (spring-framework/retag-image.sh)

	# docker tag local-docker/spring-framework-petclinic:latest stdcluster.icp:8500/default/spring-framework-petclinic:latest

#### B. 이미지 이름 확인 
	
	# docker images | grep spring-framework-petclinic

	local-docker/spring-framework-petclinic	latest	7b9b87c280af	3 days ago	491MB
	stdcluster.icp:8500/default/spring-framework-petclinic	latest	7b9b87c280af	3 days ago	491MB

#### C. ICP Private Docker Registry에 로그인
	
***확인 필요 : 로컬에서 ICP Private Docker Registry 에 연결하는 방법  ***

	# docker login stdcluster.icp:8500

#### D. ICP Private Docker Registry에 이미지 등록 (spring-framework/push-image.sh)

	# docker push stdcluster.icp:8500/default/spring-framework-petclinic		

#### E. ICP UI에서 등록된 이미지 목록 확인


&nbsp;
### Step 6. IBM Cloud Private에 샘플 애플리케이션 배포하기

#### A. Pod 생성과 노출을 위한 배포용 객체 작성 (cat spring-framework/deployment.yml)

* Service 객체 : Pod의 외부 노출을 위해 NodePort 타입 서비스를 생성합니다.
* Deployment 객체 : ReplacaSet과 그 대상인 Pod를 생성합니다. 


```
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
```

#### B. 샘플 애플리케이션 객체 배포  (spring-framework/apply-yaml.sh)

	# kubectl apply -f deployment.yaml


#### C. 배포 결과 확인

	# kubectl get deploy,svc | grep petclinic

	# curl http://<proxy:ip>:<NodePort>/petclinic/

#### D. 샘플 애플리케이션 객체 제거   (spring-framework/delete-yaml.sh)

	# kubectl delete -f deployment.yaml


