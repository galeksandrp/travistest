FROM alpine:3.16.2
RUN apk add --no-cache x11vnc \
    linux-headers \
    build-base \
    xorg-server \
    xf86-video-dummy \
    perl \
  && Xdummy -install \
  && apk del linux-headers \
    build-base
CMD ["Xdummy"]
