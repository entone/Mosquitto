FROM ubuntu:latest

MAINTAINER Guido Zockoll

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install wget build-essential libwrap0-dev libssl-dev python-distutils-extra libc-ares-dev uuid-dev libwebsockets-dev pwgen -y
RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src
RUN wget http://mosquitto.org/files/source/mosquitto-1.4.1.tar.gz
RUN tar xvzf ./mosquitto-1.4.1.tar.gz
WORKDIR /usr/local/src/mosquitto-1.4.1
RUN sed -i.bak 's/WITH_WEBSOCKETS:=no/WITH_WEBSOCKETS:=yes/' config.mk
RUN make
RUN make install
RUN /sbin/ldconfig
RUN adduser --system --disabled-password --disabled-login mosquitto
WORKDIR /home/mosquitto
ADD mosquitto.conf /etc/mosquitto/mosquitto.conf
ADD run.sh run.sh

VOLUME /var/mosquitto

EXPOSE 1883 8080
CMD /home/mosquitto/run.sh
