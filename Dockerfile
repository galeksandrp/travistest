FROM ubuntu:24.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  cron \
  && rm -rf /var/lib/apt/lists/*

CMD ["cron", "-f"]
