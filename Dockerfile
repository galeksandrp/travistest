FROM alpine:3.16.2
RUN apk add --no-cache openbox \
  terminus-font
CMD ["openbox"]
