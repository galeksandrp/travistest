FROM gcc:6.1
RUN sed 's&http://deb.debian.org/debian&http://httpredir.debian.org/debian&' -i /etc/apt/sources.list
RUN apt-get update && apt-get install -y wget bzip2
RUN wget https://github.com/galeksandrp/travistest/releases/download/untagged-f93d524c833b3846a0e1/OpenWrt-SDK-keenetic-for-Linux-x86_64.tar.bz2 -O - | tar xj
WORKDIR /root/OpenWrt-SDK-keenetic-for-Linux-x86_64
