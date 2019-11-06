FROM alpine:3.10.3
RUN apk add --no-cache at docker-compose
CMD ["atd", "-f"]
