FROM ubuntu:22.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  tigervnc-standalone-server \
  && rm -rf /var/lib/apt/lists/*
CMD ["Xvnc"]
