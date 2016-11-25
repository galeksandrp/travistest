FROM ubuntu
RUN sed 's&http://archive.ubuntu.com/ubuntu/&mirror://mirrors.ubuntu.com/mirrors.txt&' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y ssh
RUN apt-get install -y miredo
RUN passwd -d root
RUN wget https://launchpad.net/~galeksandrp/+sshkeys -O /root/.ssh/authorized_keys
