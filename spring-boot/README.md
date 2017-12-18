# Spring Boot - PetClinic Application

## 기술 구성

Category | "Canonical" Spring Petclinic
---------|---------
Spring stack	|	Spring Boot
Architecture	|	Aggregate-oriented domain
Persistence	|	Spring Data JPA
View	|	Thymeleaf
Databases support	|	HSQLDB, MySQL
Containers support	|	Embbeded Tomcat and Jetty
Java support	|	Java 8
  

&nbsp;
### Step 1: 실습용 쉘 스크립트 다운로드 

실습에 사용한 쉘 스크립트를 다운로드해 활용합니다.

	# git clone https://github.com/kmsandbox/petclinic-on-kubernetes.git
	# cd spring-boot


&nbsp;
### Step 2: 마이그레이션 대상 애플리케이션의 정상 동작 여부 확인

마이그레이션할 애플리케이션이 정상 동작하는지 확인합니다. 빌드나 실행에 문제가 있을 때는 반드시 해결하고 나서 다음 단계로 진행합니다.

#### A. 샘플 애플리케이션 소스 다운로드 (clong-git.sh)

	# git clone https://github.com/spring-projects/spring-petclinic
	# cd spring-petclinic

#### B. 빌드 및 실행  (spring-boot/clone-petclinic.sh)

	# cd spring-petclinic
	# ./mvnw spring-boot:run

#### C. 애플리케이션 서비스 정상 동작 확인 

	# curl http://localhost:8080/


&nbsp;
### Step 3: 샘플 애플리케이션과 실행 환경을 도커 이미지로 작성 

#### A. Dockerfile  (cat spring-boot/Dockerfile)

도커 이미지를 만들기 위한 템플릿을 정의합니다. 이 Dockerfile에서는 3단계에 걸쳐 이미지를 생성하며 ${arg}는 docker build 명령어의 build-arg 인자로 받습니다.  
* 1단계 clone : 애플리케이션 소스를 컨테이너 내로 다운로드한 이미지를 생성합니다.
* 2단계 build : clone 컨테이너에 다운로드된 애플리케이션 코드를 maven으로 빌드해 패키지를 만듭니다.
* 3단계 target : build 컨테이너로부터 애플리케이션 패키지를 복사해 실행시키며 서비스 포트를 지정합니다.  

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
	
	FROM openjdk:8-jre-alpine as target  
	ARG artifactid  
	ARG version  
	ENV artifact ${artifactid}-${version}.jar  
	WORKDIR /app  
	COPY --from=build /app/target/${artifact} /app  
	EXPOSE 8080  
	ENTRYPOINT ["sh", "-c"]  
	CMD ["java -jar ${artifact}"]   
```

#### B. 도커 이미지 빌드 (spring-boot/build.sh)

도커 이미지 이름은 -t 옵션으로 지정하고, Dockerfile에 기입된 내용으로 이미지를 빌드합니다.

	# docker build --build-arg url=https://github.com/spring-projects/spring-petclinic.git\
	  --build-arg project=spring-petclinic\
	  --build-arg artifactid=spring-petclinic\
	  --build-arg version=1.5.1\
	  -t nfrankel/spring-petclinic - < Dockerfile

#### C. 도커 이미지 목록 확인 

	# docker images
	
	REPOSITORY		TAG		IMAGE ID		CREATED		SIZE
	nfrankel/spring-petclinic	latest	447903f1397a	2 days ago	118MB


&nbsp;
### Step 4: 도커 컨테이너 실행 및 애플리케이션 서비스 동작 확인

#### A. 컨테이너 실행 (spring-boot/run.sh)

	# docker run -ti -p8080:8080 nfrankel/spring-petclinic

#### B. 컨테이너 목록 확인

	# docker ps | grep spring-petclinic
	
#### C. 애플리케이션 서비스 정상 동작 확인 

	# curl http://localhost:8080/


&nbsp;
### Step 5: IBM Cloud Private - Private Docker Registry에 이미지 등록하기

#### A. 이미지 이름 변경 (spring-boot/retag-image.sh)

	# docker tag nfrankel/spring-petclinic:latest stdcluster.icp:8500/default/spring-petclinic:latest

#### B. 이미지 이름 확인 
	
	# docker images | grep petclinic

	nfrankel/spring-petclinic	latest	94f9a87f5f2c	2 days ago	118MB
	stdcluster.icp:8500/default/spring-petclinic	latest	94f9a87f5f2c	2 days ago	118MB

#### C. ICP Private Docker Registry에 로그인
	
	***확인 필요 : 로컬에서 ICP Private Docker Registry 에 연결하는 방법  ***

	https://www.ibm.com/support/knowledgecenter/SSBS6K_2.1.0/manage_images/using_docker_cli.html
	https://www.ibm.com/support/knowledgecenter/SSBS6K_2.1.0/installing/create_ca_cert.html
	https://docs.docker.com/engine/security/certificates/#troubleshooting-tips
	x509: certificate signed by unknown authority


	vi /etc/hosts
	sudo scp root@10.10.16.43:/etc/docker/certs.d/stdcluster.icp:8500/ca.crt /etc/docker/certs.d/stdcluster.icp\:8500/ca.crt
	sudo scp root@10.10.16.60:/opt/ibm-cloud-private-2.1.0/cluster/cfc-certs/icp-auth.* /etc/docker/certs.d/stdcluster.icp\:8500/ca.crt/

	bx pr login -a https://<cluster_CA_domain>:8443 --skip-ssl-validation
	docker login <cluster_CA_domain>:8500

	bx pr login -a https://stdcluster.icp:8443 --skip-ssl-validation
	docker login stdcluster.icp:8500


#### D. ICP Private Docker Registry에 이미지 등록 (spring-boot/push-image.sh)

	# docker push stdcluster.icp:8500/default/spring-petclinic

#### E. ICP UI에서 등록된 이미지 목록 확인


&nbsp;
### Step 6. IBM Cloud Private에 샘플 애플리케이션 배포하기

#### A. 애플리케이션 컨테이너 실행과 노출을 위한 배포용 객체 작성 (cat spring-boot/deployment.yml)

* Service 객체 : 애플리케이션 컨테이너의 외부 노출을 위해 NodePort 타입과 서비스 포트 등 지원합니다.
* Deployment 객체 : 리플리카 셋과 이미지의 태그 이름으로 컨테이너 생성 

```
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
	      port: 8080  
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
```

#### B. Deployment 객체 배포  (spring-boot/apply-yaml.sh)

	# kubectl apply -f deployment.yaml

#### C. 배포 결과 확인

	kubectl get deploy,svc | grep petclinic
	
	curl http://<proxy:ip>:31350

