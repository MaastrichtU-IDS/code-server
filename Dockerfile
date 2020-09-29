FROM codercom/code-server:latest

USER root

RUN apt-get update -y

RUN apt-get install software-properties-common build-essential openjdk-11-jdk maven gfortran vim nano wget curl -y

USER coder