FROM alpine:3.16.2
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing novnc
CMD ["novnc_server"]
