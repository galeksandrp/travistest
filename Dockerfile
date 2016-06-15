FROM ubuntu:24.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  wget \
  locales \
  apt-utils \
  && rm -rf /var/lib/apt/lists/*
RUN locale-gen ru_RU.UTF-8

WORKDIR /root
RUN wget https://repo.postgrespro.ru/1c/1c-16/keys/pgpro-repo-add.sh
RUN (echo '8a72e2fd0fa416fd66a71c5de8fa0de81689ff531f3d6fc92a39e85241194773  pgpro-repo-add.sh' | sha256sum -c) \
  && chmod +x pgpro-repo-add.sh \
  && ./pgpro-repo-add.sh \
  && rm -rf pgpro-repo-add.sh

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  postgrespro-1c-16 \
  && (echo 'Sleeping time' && sleep 300) \
  && /etc/init.d/postgrespro-1c-16 stop \
  && rm -rf /var/lib/apt/lists/*
USER postgres

CMD ["bash", "-c", "((sleep 30 \
    && psql -c \"ALTER USER postgres PASSWORD '$POSTGRES_PASSWORD';\" \
    && (createuser --no-password $POSTGRES_USER \
      ; psql -c \"ALTER USER $POSTGRES_USER PASSWORD '$POSTGRES_USER_PASSWORD';\") \
      && createdb --owner=$POSTGRES_USER $POSTGRES_DB) &) \
  && exec /opt/pgpro/1c-16/bin/postgres -D /var/lib/pgpro/1c-16/data"]
