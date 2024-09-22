FROM openjdk:11-jdk
COPY /src app/src
COPY pom.xml app/
COPY system.properties app/
WORKDIR app
RUN apt-get update
RUN apt-get -y install maven
RUN apt-get -y install pandoc
RUN apt-get -y install texlive-xetex
RUN mvn package
CMD sh target/bin/simplewebapp
