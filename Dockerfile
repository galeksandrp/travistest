FROM alpine/git

COPY cron.sh /root/cron.sh
RUN chmod +x /root/cron.sh

RUN apk update --no-cache && apk add --no-cache \
    cron
