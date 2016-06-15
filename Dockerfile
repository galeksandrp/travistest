FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
  software-properties-common \
  wget \
  && rm -rf /var/lib/apt/lists/*
RUN wget -qO /etc/apt/trusted.gpg.d/GPG-KEY-POSTGRESPRO.asc http://repo.postgrespro.ru/keys/GPG-KEY-POSTGRESPRO
RUN add-apt-repository 'deb https://repo.postgrespro.ru/pg1c-12/ubuntu jammy main'
RUN apt-get update && apt-get install -y \
  postgrespro-1c-12 \
  && sleep 300 \
  && /etc/init.d/postgrespro-1c-12 stop \
  && rm -rf /var/lib/apt/lists/*
USER postgres
CMD [ "/opt/pgpro/1c-12/bin/postgres", "-D", "/var/lib/pgpro/1c-12/data" ]
