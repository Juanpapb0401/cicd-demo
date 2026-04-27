FROM amazoncorretto:17
VOLUME /tmp
COPY target/cicd-demo-*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]