FROM alpine:20200917
RUN apk add --no-cache certbot-apache docker-compose docker
FROM alpine:20200917
RUN apk add --no-cache certbot-apache docker-compose docker curl
ADD apache2ctl /usr/sbin/apache2ctl
RUN chmod +x /usr/sbin/apache2ctl
