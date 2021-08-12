FROM openjdk:8u111-jdk
RUN sed 's&http://deb.debian.org/debian&http://httpredir.debian.org/debian&' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y wget
RUN mkdir -p /root/billing
WORKDIR /root/billing
RUN wget http://www.netams.com/files/netams4/netams4.0.1640-linux-x64.tar.gz -O - | tar xz
RUN ln -s $(dirname $(which java))/.. java
