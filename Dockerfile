FROM ubuntu:xenial
RUN apt-get update && apt-get install -y git offlineimap wget
RUN wget https://github.com/papertrail/remote_syslog2/releases/download/v0.20/remote-syslog2_0.20_amd64.deb
RUN dpkg -i remote-syslog2_0.20_amd64.deb
