FROM ubuntu:xenial-20160713
RUN sed 's&http://archive.ubuntu.com/ubuntu/&mirror://mirrors.ubuntu.com/mirrors.txt&' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y ssh
RUN apt-get install -y miredo
RUN passwd -d root
COPY authorized_keys /root/.ssh/authorized_keys
COPY build.sh /root/build.sh
RUN chmod +x ~/build.sh
CMD ["/bin/sh" "-c" "~/build.sh"]
