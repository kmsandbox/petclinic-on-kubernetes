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
