FROM galeksandrp/travistest:docker-build-android
RUN apt-get update && apt-get install -y software-properties-common wget
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN mkdir -p /var/cache/oracle-jdk7-installer
RUN wget https://github.com/galeksandrp/travistest/releases/download/untagged-f93d524c833b3846a0e1/jdk-6u45-linux-x64.bin -P /var/cache/oracle-jdk7-installer
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get install -y oracle-java6-installer
