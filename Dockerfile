FROM ubuntu:20.04
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
  curl \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  ttf-mscorefonts-installer \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /root/1c-installer/untar
RUN curl -L 'https://github.com/galeksandrp/galeksandrp/releases/download/1c/server64_8_3_20_1674.tar.gz' | tar xz -C /root/1c-installer/untar \
  && /root/1c-installer/untar/setup-full-*-x86_64.run \
    --mode unattended \
    --enable-components server \
    --disable-components client_full \
    --installer-language en \
  && rm -rf /root/1c-installer
CMD [ "sh", "-c", "/opt/1cv8/x86_64/8.3.20.1674/srv1cv83 start && exec tail --pid=$(pidof ragent) -f /dev/null" ]
