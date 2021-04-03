FROM archlinux
RUN pacman -Syu --noconfirm pptpd
COPY pptpd.conf /etc/pptpd.conf
COPY options.pptpd /etc/ppp/options.pptpd

# app additional config

RUN pacman -Syu --noconfirm iproute2 jq

COPY ip-common-accel.sh /etc/ppp/ip-common-accel.sh

COPY 01-ip-up-iptables.sh /etc/ppp/ip-up.d/01-ip-up-iptables.sh
RUN chmod +x /etc/ppp/ip-up.d/01-ip-up-iptables.sh

COPY 01-ip-down-iptables.sh /etc/ppp/ip-down.d/01-ip-down-iptables.sh
RUN chmod +x /etc/ppp/ip-down.d/01-ip-down-iptables.sh

CMD ["pptpd", "-f"]
