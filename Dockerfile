FROM alpine
# https://openwrt.org/docs/guide-developer/build-system/install-buildsystem#alpine
RUN apk add --update asciidoc \
  bash \
  bc \
  binutils \
  bzip2 \
  cdrkit \
  coreutils \
  diffutils \
  findutils \
  flex \
  g++ \
  gawk \
  gcc \
  gettext \
  git \
  grep \
  intltool \
  libxslt \
  linux-headers \
  make \
  ncurses-dev \
  openssl-dev \
  patch \
  perl \
  python2-dev \
  python3-dev \
  rsync \
  tar \
  unzip \
  util-linux \
  wget \
  zlib-dev \
# https://openwrt.org/docs/guide-developer/build-system/install-buildsystem#prerequisites
  help2man \
  libelf-dev \
# README.md
  libc-dev \
  subversion
RUN git config --global user.email "you@example.com"
RUN git config --global user.name "Your Name"
WORKDIR /root/openwrt
CMD ./scripts/feeds update -a \
&& ./scripts/feeds install -a \
make
