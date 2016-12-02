FROM archlinux
RUN pacman -Syu --noconfirm xl2tpd
COPY xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
COPY options.l2tpd /etc/ppp/options.l2tpd

COPY 01-ip-up-iptables.sh /etc/ppp/ip-up.d/01-ip-up-iptables.sh
RUN chmod +x /etc/ppp/ip-up.d/01-ip-up-iptables.sh

COPY 01-ip-down-iptables.sh /etc/ppp/ip-down.d/01-ip-down-iptables.sh
RUN chmod +x /etc/ppp/ip-down.d/01-ip-down-iptables.sh

CMD iptables -t nat -A POSTROUTING -m mark --mark 7368816 -j MASQUERADE && \
xl2tpd -D ; \
APP_EXIT_CODE="$?" && \
iptables -t nat -D POSTROUTING -m mark --mark 7368816 -j MASQUERADE ; \
exit $APP_EXIT_CODE
