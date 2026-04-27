FROM eclipse-temurin:17-jdk-alpine
VOLUME /tmp
COPY target/cicd-demo-*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]