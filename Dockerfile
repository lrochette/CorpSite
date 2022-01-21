#
# Build stage
#
FROM maven:3.3-jdk-8 AS build

COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

#
# Package stage
#
FROM tomcat:9.0

COPY --from=build /home/app/target/globex-web.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]
