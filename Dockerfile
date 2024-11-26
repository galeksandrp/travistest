FROM galeksandrp/travistest:docker-pg1c-16
USER root
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  cron \
  curl \
  jq \
  && rm -rf /var/lib/apt/lists/*

COPY scripts /root/scripts

CMD ["bash", "-c", "crontab /root/cron/crontabs/* && crontab -l && exec cron -f"]
