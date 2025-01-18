FROM openwrt/rootfs

RUN opkg update
RUN opkg install nano luci
