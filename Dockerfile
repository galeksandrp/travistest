FROM ubuntu:24.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  libncurses-dev \
  zlib1g-dev \
  gawk \
  git \
  gettext \
  libssl-dev \
  xsltproc \
  rsync \
  wget \
  unzip \
  python3 \
  python3-distutils-extra \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  wget \
  zstd \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root
RUN wget https://downloads.openwrt.org/releases/25.12.4/targets/x86/64/openwrt-imagebuilder-25.12.4-x86-64.Linux-x86_64.tar.zst \
  && tar --zstd -x -f openwrt-imagebuilder-*.tar.zst \
  && rm -rf openwrt-imagebuilder-*.tar.zst
WORKDIR /root/openwrt-imagebuilder-25.12.4-x86-64.Linux-x86_64

ENV FIRMWARE_SELECTOR_PACKAGES="apk-mbedtls base-files ca-bundle dnsmasq dropbear e2fsprogs firewall4 fstools grub2-bios-setup kmod-button-hotplug kmod-nft-offload libc libgcc libustream-mbedtls logd mkf2fs mtd netifd nftables odhcp6c odhcpd-ipv6only partx-utils ppp ppp-mod-pppoe procd-ujail uci uclient-fetch urandom-seed urngd kmod-amazon-ena kmod-amd-xgbe kmod-bnx2 kmod-dwmac-intel kmod-e1000e kmod-e1000 kmod-forcedeth kmod-fs-vfat kmod-igb kmod-igc kmod-ixgbe kmod-r8169 kmod-tg3 kmod-drm-i915 luci luci-app-attendedsysupgrade"
ENV CUSTOM_PACKAGES="nano-full luci-proto-wireguard htop luci-app-ttyd luci-app-attendedsysupgrade luci-app-keepalived luci-theme-openwrt-2020 luci-app-filemanager"
RUN make image \
  PACKAGES="$FIRMWARE_SELECTOR_PACKAGES $CUSTOM_PACKAGES" \
  && rm -rf bin

CMD ["sh", "-c", "make image PACKAGES=\"$FIRMWARE_SELECTOR_PACKAGES $CUSTOM_PACKAGES\""]
