FROM alpine
RUN apk update --no-cache && apk add --no-cache \
    tor

USER tor

CMD ["/usr/bin/tor"]
