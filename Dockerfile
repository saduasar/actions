# Stage 1: Build stage using Maven
FROM openjdk:11 AS build


RUN apt update && apt install maven -y

# Set the working directory inside the container for the build stage
WORKDIR /build

# Copy the entire content of the current directory into the Docker image
COPY . .

# Build the Maven project and package it into a WAR file
RUN mvn clean install

# Stage 2: Deployment stage using Tomcat
FROM tomcat:9-jre11

# Remove any existing files related to the default ROOT application in Tomcat's webapps directory
RUN rm -rf /usr/local/tomcat/webapps/ROOT*

# Copy the WAR file from the previous build stage into the Tomcat webapps directory, renaming it to ROOT.war
COPY --from=build /build/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 to allow external access to the Tomcat server
EXPOSE 8080

# Set the default command to run Tomcat using catalina.sh
CMD ["catalina.sh", "run"]
