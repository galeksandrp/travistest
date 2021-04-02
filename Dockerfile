FROM archlinux
RUN pacman -Syu --noconfirm xl2tpd
COPY xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
COPY options.l2tpd /etc/ppp/options.l2tpd

# app additional config

RUN pacman -Syu --noconfirm iproute2 jq

COPY ip-common-accel.sh /etc/ppp/ip-common-accel.sh

COPY 01-ip-up-iptables.sh /etc/ppp/ip-up.d/01-ip-up-iptables.sh
RUN chmod +x /etc/ppp/ip-up.d/01-ip-up-iptables.sh

COPY 01-ip-down-iptables.sh /etc/ppp/ip-down.d/01-ip-down-iptables.sh
RUN chmod +x /etc/ppp/ip-down.d/01-ip-down-iptables.sh

CMD ["xl2tpd", "-D"]
