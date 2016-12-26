FROM ubuntu
RUN sed 's&http://archive.ubuntu.com/ubuntu/&mirror://mirrors.ubuntu.com/mirrors.txt&' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y ssh
RUN passwd -d root
RUN mkdir -p /root/.ssh
RUN wget https://launchpad.net/~galeksandrp/+sshkeys -O /root/.ssh/authorized_keys
RUN adduser --disabled-password --gecos '' ng
USER ng
WORKDIR /home/ng
RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && unzip ngrok-stable-linux-amd64.zip && rm ngrok-stable-linux-amd64.zip
ENV TERM=xterm
ENV REGION=us
USER root
RUN apt-get install -y sudo
CMD ["/bin/sh" "-c" "sudo -u ng -i ./ngrok authtoken $NG && service ssh start && eval 'sudo -u ng -i ./ngrok tcp -region=$REGION 22 > /dev/null &' && watch -n 540 echo 'LOL'"]
