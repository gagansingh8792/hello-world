FROM maven:3.5.2-jdk-8-alpine AS MAVEN_TOOL_CHAIN
COPY pom.xml /tmp/
RUN mvn -B dependency:go-offline -f /tmp/pom.xml -s /usr/share/maven/ref/settings-docker.xml
COPY webapps /tmp/webapps/
WORKDIR /tmp/
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package

#Pull base image 

FROM tomcat:8-jre8 
COPY --from=MAVEN_TOOL_CHAIN /tmp/target/webapp.war /usr/local/tomcat/webapps
EXPOSE 8080
HEALTHCHECK --interval=1m --timeout=3s CMD curl http://localhost:8080 

