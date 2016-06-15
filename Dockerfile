FROM ubuntu:20.04 AS server
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  curl \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /root/1c-setup/untar \
  && curl -L 'https://github.com/galeksandrp/galeksandrp/releases/download/1c/deb64_8_3_23_1912.tar.gz' | tar xz -C /root/1c-setup/untar \
  && dpkg -i /root/1c-setup/untar/*.deb \
  && rm -rf /root/1c-setup
CMD [ "/opt/1cv8/x86_64/8.3.23.1912/ragent", "-d", "/home/usr1cv8/.1cv8/1C/1cv8", "-port", "1540", "-regport", "1541", "-range", "1560:1591", "-seclev", "0", "-pingPeriod", "1000", "-pingTimeout", "5000" ]

FROM server AS client
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  libgtk-3-0 \
  libenchant1c2a \
  libharfbuzz-icu0 \
  libgstreamer1.0-0 \
  libgstreamer-plugins-base1.0-0 \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  libsecret-1-0 \
  libsoup2.4-1 \
  libsqlite3-0 \
  libgl1 \
  libegl1 \
  libxrender1 \
  libxfixes3 \
  libxslt1.1 \
  geoclue-2.0 \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  libgl1-mesa-glx \
  iproute2 \
  ttf-mscorefonts-installer \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /root/1c-setup/untar \
  && curl -L 'https://github.com/galeksandrp/galeksandrp/releases/download/1c/client_8_3_23_1912.deb64.tar.gz' | tar xz -C /root/1c-setup/untar \
  && rm -rf /root/1c-setup/untar/*-thin-client*.deb \
  && dpkg -i /root/1c-setup/untar/*.deb \
  && rm -rf /root/1c-setup
# docker run --init required, -v/tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY for GUI
CMD [ "sh", "-c", "/opt/1cv8/x86_64/8.3.23.1912/1cv8s && APPPID=$(pidof 1cv8 || pidof 1cv8c) && exec tail --pid=$APPPID -f /dev/null" ]
