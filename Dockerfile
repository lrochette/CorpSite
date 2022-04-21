FROM tomcat:9.0

COPY target/globex.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]
