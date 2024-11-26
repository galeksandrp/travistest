FROM galeksandrp/travistest:docker-pg1c-16
USER root
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  cron \
  && rm -rf /var/lib/apt/lists/*

CMD ["bash", "-c", "crontab /root/cron/crontabs/* && crontab -l && exec cron -f"]
