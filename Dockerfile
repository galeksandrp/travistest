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
RUN wget https://downloads.openwrt.org/snapshots/targets/qualcommax/ipq807x/openwrt-imagebuilder-qualcommax-ipq807x.Linux-x86_64.tar.zst \
  && tar --zstd -x -f openwrt-imagebuilder-*.tar.zst \
  && rm -rf openwrt-imagebuilder-*.tar.zst
WORKDIR /root/openwrt-imagebuilder-qualcommax-ipq807x.Linux-x86_64

ENV CUSTOM_PROFILE="xiaomi_ax3600"
ENV CUSTOM_PACKAGES="ath10k-firmware-qca9887-ct ath11k-firmware-ipq8074 base-files busybox ca-bundle dnsmasq dropbear e2fsprogs firewall4 fstools ipq-wifi-xiaomi_ax3600 kmod-ath10k-ct-smallbuffers kmod-ath11k-ahb kmod-fs-ext4 kmod-gpio-button-hotplug kmod-leds-gpio kmod-nft-offload kmod-phy-aquantia kmod-qca-nss-dp kmod-usb-dwc3 kmod-usb-dwc3-qcom kmod-usb3 libc libgcc libustream-openssl logd losetup luci mtd netifd nftables odhcp6c odhcpd-ipv6only opkg ppp ppp-mod-pppoe procd procd-seccomp procd-ujail uboot-envtools uci uclient-fetch urandom-seed urngd wpad-openssl        luci-app-upnp luci-app-wol 6in4 6rd 6to4 freeradius3-default freeradius3-utils eapol-test-openssl libopenssl-legacy nano-full luci-proto-wireguard htop stubby luci-app-sqm luci-app-ttyd luci-app-attendedsysupgrade luci-app-acme acme-acmesh-dnsapi luci-app-squid diffutils jq libnetfilter-conntrack3        -libustream-mbedtls -wpad-basic-mbedtls"
RUN make image \
  PROFILE="$CUSTOM_PROFILE" \
  PACKAGES="$CUSTOM_PACKAGES" \
  && rm -rf bin

CMD ["sh", "-c", "make image PROFILE=\"$CUSTOM_PROFILE\" PACKAGES=\"$CUSTOM_PACKAGES\""]
