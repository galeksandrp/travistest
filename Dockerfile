FROM ubuntu:22.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  apt-transport-https \
  software-properties-common \
  ca-certificates \
  wget \
  && rm -rf /var/lib/apt/lists/*
RUN wget -O "/usr/share/keyrings/xpra-2022.gpg" https://xpra.org/xpra-2022.gpg
RUN wget -O "/usr/share/keyrings/xpra-2018.gpg" https://xpra.org/xpra-2018.gpg
RUN wget -O "/usr/share/keyrings/xpra.gpg" https://xpra.org/xpra.gpg
RUN wget -O "/etc/apt/sources.list.d/xpra.list" https://xpra.org/repos/jammy/xpra.list
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  xpra \
  x11-xserver-utils \
  && rm -rf /var/lib/apt/lists/*
CMD ["xpra", "start", ":14", "--bind-tcp=0.0.0.0:10000", "--daemon=no"]
