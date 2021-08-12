FROM alpine:3.5
RUN apk add --update alpine-sdk
RUN adduser -D ng -G abuild
RUN mkdir -p /var/cache/distfiles/
RUN chown -R ng:abuild /var/cache/distfiles/
USER ng
WORKDIR /home/ng
CMD abuild-keygen -n -a && abuild checksum && abuild -r
