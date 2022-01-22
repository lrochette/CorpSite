#
# Build stage
#
FROM maven:3.3-jdk-8 AS build

COPY src /usr/src/app/src
COPY pom.xml /usr/src/app
RUN mvn -f /usr/src/app/pom.xml clean package

#
# Package stage
#
FROM tomcat:9.0

COPY --from=build /usr/src/app/target/globex-web.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]
