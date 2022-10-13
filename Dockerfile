FROM alpine:3.16.2
RUN apk add --no-cache xrdp \
  xorg-server \
  xorgxrdp
RUN echo 'allowed_users = anybody' > /etc/X11/Xwrapper.config
# requires docker run --init or compose init: true
CMD ["sh", "-c", "xrdp-sesman && exec xrdp --nodaemon"]
