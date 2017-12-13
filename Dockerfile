FROM ubuntu:xenial
RUN sed 's&http://archive.ubuntu.com/ubuntu/&mirror://mirrors.ubuntu.com/mirrors.txt&' -i /etc/apt/sources.list
RUN apt-get update && apt-get install -y git build-essential cmake libncurses5-dev bison
