FROM alpine:3.16.2
RUN apk add --no-cache xorg-server \
    xf86-video-dummy \
    xrandr
