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
RUN wget -O /usr/share/X11/xorg.conf.d/20-xdummy.conf https://raw.githubusercontent.com/Xpra-org/xpra/master/fs/etc/xpra/xorg.conf
CMD ["Xdummy"]
