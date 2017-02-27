FROM ubuntu
RUN sed 's&http://archive.ubuntu.com/ubuntu/&mirror://mirrors.ubuntu.com/mirrors.txt&' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y wget lib32gcc1
RUN adduser --disabled-password --gecos '' css
USER css
WORKDIR /home/css
RUN mkdir -p ~/steamcmd
WORKDIR /home/css/steamcmd
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -O - | tar xz
RUN ./steamcmd.sh +login anonymous +force_install_dir ~/css +app_update 232330 +quit
WORKDIR /home/css/steamcmd
EXPOSE 27015
CMD ["./srcds_run", "-console", "-game cstrike", "+map de_dust2"]
