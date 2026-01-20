FROM galeksandrp/travistest:docker-1c-8-3-27-1859-client AS client-orig

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  xvfb \
  psmisc \
  && rm -rf /var/lib/apt/lists/*

FROM client-orig AS builder

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  gcc \
  libx11-dev \
  && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/galeksandrp/dockerfile-x11docker-xserver/raw/878a18b673f25da105914cf6a2b80a3a5e456cfb/XlibNoSHM.c
RUN cc -shared -o /root/XlibNoSHM.so XlibNoSHM.c

FROM client-orig AS client

COPY --from=builder /root/XlibNoSHM.so /root/XlibNoSHM.so

COPY 1cv8s.sh /root/1cv8s.sh
RUN chmod +x /root/1cv8s.sh

ENV APP_VERSION=8.3.27.1859

CMD ["/root/1cv8s.sh"]
