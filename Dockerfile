#stage-1 Build the application
From maven:3.9.9-amazoncorretto-21 AS build
WORKDIR / app

COPY pom.xml /app

COPY src/app/src

RUN mvn clean package -DskipTests

#stage-2 : Run the application
FROM maven:3.9.6-eclipse-amazoncorretto-21-alpine

COPY ./target/app_name-*.jar /app/app.jar

#use root user to adjust permissions
USER root

#create required directories and set permision
RUN mkdir -p/var/log/app_name && chmod -R 775 /var/log/app_name

#change ownership of directories to the non-root user
RUN chown _R 1000:2000 /app /var/log/app_name

#switch to the non-root user
USER 1000
#Expose application port
EXPOSE 8080

#JVM options for dynamic heap allocation and GC optimization

# Redis configuration to handle disk persistence issues
ENV REDIS_CONNECT_TIMEOUT=10000
ENV REDIS_RETRY_ATTEMPTS=3

#optional volume for persitent logs
VOLUME /var/log/app_name

#Run the application
CMD["java", "-jar","/app/app_name.jar"]