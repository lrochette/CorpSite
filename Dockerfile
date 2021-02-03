FROM tomcat:9.0

COPY target/globex-web.war /usr/local/tomcat
CMD ["catalina.sh", "run"]
