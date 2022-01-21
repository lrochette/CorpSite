FROM maven:3.3-jdk-8 as build
mvn package

FROM tomcat:9.0

COPY --from=build target/globex-web.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]
