FROM alpine:3.22.1
RUN apk update --no-cache && apk add --no-cache \
    rsync
