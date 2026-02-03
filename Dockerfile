FROM alpine:3.23.3
# https://openwrt.org/docs/guide-developer/build-system/install-buildsystem#alpine
RUN apk add --update argp-standalone \
  asciidoc \
  bash \
  bc \
  binutils \
  bzip2 \
  cdrkit \
  coreutils \
  diffutils \
  elfutils-dev \
  findutils \
  flex \
  musl-fts-dev \
  g++ \
  gawk \
  gcc \
  gettext \
  git \
  grep \
  gzip \
  intltool \
  libxslt \
  linux-headers \
  make \
  musl-libintl \
  musl-obstack-dev \
  ncurses-dev \
  openssl-dev \
  patch \
  perl \
  python3-dev \
  rsync \
  tar \
  unzip \
  util-linux \
  wget \
  zlib-dev \
# https://openwrt.org/docs/guide-developer/build-system/install-buildsystem#prerequisites
  time \
  help2man \
  swig \
  which \
# README.md
  subversion
RUN adduser -D ng
RUN git config --global user.email "you@example.com"
RUN git config --global user.name "Your Name"
USER ng
WORKDIR /home/ng/openwrt
CMD ./scripts/feeds update -a \
&& ./scripts/feeds install -a \
exec make
