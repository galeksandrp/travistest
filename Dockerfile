FROM ubuntu:24.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  apt-transport-https \
  software-properties-common \
  ca-certificates \
  wget \
  && rm -rf /var/lib/apt/lists/*

RUN wget -O "/usr/share/keyrings/xpra.asc" https://xpra.org/xpra.asc
RUN wget -O "/etc/apt/sources.list.d/xpra.sources" https://raw.githubusercontent.com/Xpra-org/xpra/master/packaging/repos/noble/xpra.sources

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  xpra \
  x11-xserver-utils \
  && rm -rf /var/lib/apt/lists/*
CMD ["xpra", "start", ":14", "--bind-tcp=0.0.0.0:10000", "--daemon=no"]
