FROM alpine:3.10.3
RUN apk add --no-cache atd
CMD ["atd", "-f"]
