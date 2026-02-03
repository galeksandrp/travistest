FROM ubuntu:22.04

RUN apt-get -y update && apt-get install -y wget

WORKDIR /root

RUN wget https://github.com/galeksandrp/galeksandrp/releases/download/1c/ubuntu22_regime_1.5.2-600_amd64.deb \
  && apt-get -y update \
  && apt-get upgrade -y \
  && apt-get install -y ./ubuntu22_regime_1.5.2-600_amd64.deb \
  && rm -rf ubuntu22_regime_1.5.2-600_amd64.deb

RUN apt-get -y update \
  && apt-get upgrade -y \
  && apt-get install -y python3

RUN wget https://github.com/gdraheim/docker-systemctl-replacement/raw/refs/tags/v1.7.1064/files/docker/systemctl3.py -O /usr/bin/systemctl
RUN chmod +x /usr/bin/systemctl

CMD ["/usr/bin/systemctl"]
