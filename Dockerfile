FROM alpine:3.13.5
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
  libelf \
  perl-extutils-makemaker \
# README.md
  libc-dev \
  subversion
RUN adduser -D ng
RUN git config --global user.email "you@example.com"
RUN git config --global user.name "Your Name"
USER ng
WORKDIR /home/ng/openwrt
CMD ./scripts/feeds update -a \
&& ./scripts/feeds install -a \
make
