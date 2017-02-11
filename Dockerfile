FROM ubuntu
RUN sed 's&http://archive.ubuntu.com/ubuntu/&mirror://mirrors.ubuntu.com/mirrors.txt&' -i /etc/apt/sources.list
RUN apt-get update
ADD apt-get install -y lib32gcc1
RUN mkdir -p ~/steamcmd
WORKDIR ~/steamcmd
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -O - | tar xz
RUN ./steamcmd.sh +login anonymous +force_install_dir ~/css +app_update 232330 +quit
WORKDIR ~/css
EXPOSE 27015
RUN ["./srcds_run", "-console", "-game cstrike", "+map de_dust2"]
