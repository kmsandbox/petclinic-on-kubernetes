# 스프링 애플리케이션을 IBM Cloud Private - Kubernetes에 마이그레이션 하기
  
* 스프링 기반 샘플 애플리케이션 **PetClinic**을 컨테이너 이미지로 만들어 ICP의 Private Docker Regitry에 등록하고, 배포 스크립트인 Deployment.yaml를 작성해 애플리케이션을 쿠버네티스 클러스터에 배포하는 과정을 설명합니다.

* 마이그레이션 실습 대상은 3가지 입니다.
	1. Spring Canonical : Spring Boot 
	2. Spring Framework : Spring Framework
	3. Microservices : Spring Cloud

### 목차
1. Spring PetClinc 샘플 애플리케이션 소개
2. 실습 사전요건 안내
  
## Spring PetClinic 샘플 애플리케이션

* 소유자, 애완동물, 진료예약, 수의사 등록 및 관리

* Sample application designed to show how the Spring application frameworks canbe used to build simple, but powerful database-oriented applications

* Exists many versions (forks) of the Spring Petclinic sample application

### Spring PetClinic의 다양한 버전

* The Spring Petclinic master branch in the main spring-projects GitHub org is the "canonical" implementation, currently based on Spring Boot and Thymeleaf. There are quite a few forks in a special GitHub org spring-petclinic. If you have a special interest in a different technology stack that could be used to implement the Pet Clinic then please join the community there.

Link	| Main technologies
-------|-----
[spring-framework-petclinic](https://github.com/spring-petclinic/spring-framework-petclinic)	| Spring Framework XML configuration, JSP pages, 3 persistence layers: JDBC, JPA and Spring Data JPA
[spring-petclinic-microservices](https://github.com/spring-petclinic/spring-petclinic-microservices)	| Distributed version of Spring Petclinic built with Spring Cloud
[spring-petclinic-angularjs](https://github.com/spring-petclinic/spring-petclinic-angularjs)	| AngularJS 1.x, Spring Boot and Spring Data JPA
[spring-petclinic-angular](https://github.com/spring-petclinic/spring-petclinic-angular)	| Angular 4 front-end of the Petclinic REST API [spring-petclinic-rest](https://github.com/spring-petclinic/spring-petclinic-rest)
[spring-petclinic-rest](https://github.com/spring-petclinic/spring-petclinic-rest)	|	Backend REST API
[spring-petclinic-reactjs](https://github.com/spring-petclinic/spring-petclinic-reactjs)	| ReactJS (with TypeScript) and Spring Boot
[spring-petclinic-graphql](https://github.com/spring-petclinic/spring-petclinic-graphql)	| GraphQL version based on React Appolo, TypeScript and GraphQL Spring boot starter
[spring-petclinic-kotlin](https://github.com/spring-petclinic/spring-petclinic-kotlin)		| Kotlin version of spring-petclinic


#### Spring PetClinic: Domain Model

![Domain model](images/Domain_Model.png)

#### Spring PetClinic: Screenshots

![Welcome](images/UI_Welcome.png)

![](images/UI_OwnerFind.png)

![](images/UI_OwnerList.png)

![](images/UI_OwnerDetail.png)

![](images/UI_VetsList.png) 

  
## 실습 사전요건

1. Maven - [Install](https://maven.apache.org/install.html)
2. Docker Toolbox [Install](https://docs.docker.com/toolbox/overview/)
3. Minikube [Install](https://github.com/kubernetes/minikube)
4. ICP [Install](https://github.com/IBM/deploy-ibm-cloud-private/blob/master/docs/deploy-vagrant.md)
5. Kubectl [Install](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
6. Kompose [Install](https://github.com/kubernetes/kompose)
7. IBM Cloud CLI  [Install](https://console.bluemix.net/docs/cli/reference/bluemix_cli/get_started.html#getting-started)
7. IBM Cloud Private CLI - bx pr [Install](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_2.1.0/manage_cluster/install_cli.html)









