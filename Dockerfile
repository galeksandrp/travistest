FROM debian:bookworm-20240130
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  wget \
  && rm -rf /var/lib/apt/lists/*

RUN echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
RUN wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  ifenslave \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  proxmox-ve \
  ifupdown2- \
  && rm -rf /var/lib/apt/lists/*

RUN rm -rf /etc/apt/sources.list.d/pve-enterprise.list

STOPSIGNAL SIGRTMIN+3

RUN echo 'root:root' | chpasswd

CMD ["/usr/sbin/init"]
