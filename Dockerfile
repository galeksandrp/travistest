FROM ubuntu:20.04 AS common
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  wget \
  unzip \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /root/1c-setup/untar \
  && cd /root/1c-setup/untar \
  && wget 'https://github.com/galeksandrp/galeksandrp/releases/download/1c/deb64_8_3_25_1374.zip' \
  && unzip *.zip \
  && apt-get install -y /root/1c-setup/untar/*.deb \
  && rm -rf /root/1c-setup
FROM common AS server
CMD [ "/opt/1cv8/x86_64/8.3.25.1374/ragent", "-d", "/home/usr1cv8/.1cv8/1C/1cv8", "-port", "1540", "-regport", "1541", "-range", "1560:1591", "-seclev", "0", "-pingPeriod", "1000", "-pingTimeout", "5000" ]

FROM common AS client
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
  && cd /root/1c-setup/untar \
  && wget 'https://github.com/galeksandrp/galeksandrp/releases/download/1c/client_8_3_25_1374.deb64.zip' \
  && unzip *.zip \
  && rm -rf /root/1c-setup/untar/*-thin-client*.deb \
  && apt-get install -y /root/1c-setup/untar/*.deb \
  && rm -rf /root/1c-setup
# docker run --init required, -v/tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY for GUI
CMD [ "sh", "-c", "/opt/1cv8/x86_64/8.3.25.1374/1cv8s && APPPID=$(pidof 1cv8 || pidof 1cv8c) && exec tail --pid=$APPPID -f /dev/null" ]
