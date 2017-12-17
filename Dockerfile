FROM ubuntu:xenial
RUN sed 's&http://archive.ubuntu.com/ubuntu/&mirror://mirrors.ubuntu.com/mirrors.txt&' -i /etc/apt/sources.list
RUN apt-get update && apt-get install -y git wget build-essential python
RUN git clone https://github.com/c9/core.git ~/c9sdk
WORKDIR /root/c9sdk
RUN scripts/install-sdk.sh
CMD /root/.c9/node/bin/node server.js -p $PORT -a $USERNAME:$PASSWORD
