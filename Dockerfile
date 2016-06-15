FROM galeksandrp/travistest:docker-1c-8-3-27-1859-client AS client

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  xvfb \
  psmisc \
  && rm -rf /var/lib/apt/lists/*

COPY 1cv8s.sh /root/1cv8s.sh
RUN chmod +x /root/1cv8s.sh

ENV APP_VERSION=8.3.27.1859

CMD ["/root/1cv8s.sh"]
