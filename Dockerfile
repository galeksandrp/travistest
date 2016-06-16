FROM ubuntu
RUN sed 's&http://archive.ubuntu.com/ubuntu/&mirror://mirrors.ubuntu.com/mirrors.txt&' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y wget
RUN passwd -d root
RUN adduser --disabled-password --gecos '' ng
RUN apt-get install -y sudo
RUN apt-get install -y unzip
WORKDIR /home/ng
RUN sudo -u ng wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
RUN sudo -u ng unzip ngrok-stable-linux-amd64.zip && rm ngrok-stable-linux-amd64.zip
CMD echo lollollol1
