FROM openjdk:17-jdk-slim
VOLUME /tmp
COPY target/cicd-demo-*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]