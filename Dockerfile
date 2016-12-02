FROM archlinux AS archlinux-updated
RUN pacman -Syu --noconfirm

FROM archlinux-updated AS archlinux-sudo
RUN pacman -Syu --noconfirm sudo
RUN sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
RUN grep '^%wheel ALL=(ALL) NOPASSWD: ALL' /etc/sudoers || echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# ng

FROM archlinux-sudo AS archlinux-ng
RUN useradd -G wheel -m ng
WORKDIR /home/ng

FROM archlinux-ng AS archlinux-ng-toolchain
RUN pacman -Syu --noconfirm base-devel

# pkg

FROM archlinux-ng-toolchain AS archlinux-pkg
RUN pacman -Syu --noconfirm git
RUN sudo -u ng git clone https://aur.archlinux.org/accel-ppp-git.git pkg
WORKDIR /home/ng/pkg
COPY 0001-Use-CMake-PPTP-ctrl-link-fix.patch /home/ng/pkg
RUN patch -p1 <0001-Use-CMake-PPTP-ctrl-link-fix.patch
RUN sudo -u ng makepkg -s --noconfirm

# app

FROM archlinux-updated
COPY --from=archlinux-pkg /home/ng/pkg/*.pkg* /root/pkg/
RUN pacman -U --noconfirm /root/pkg/*.pkg*
COPY accel-ppp.conf /etc/accel-ppp.conf

# app additional config

RUN pacman -Syu --noconfirm iproute2

COPY ip-pre-up-accel /etc/ppp/ip-pre-up-accel
RUN chmod +x /etc/ppp/ip-pre-up-accel

COPY ip-down-accel /etc/ppp/ip-down-accel
RUN chmod +x /etc/ppp/ip-down-accel

CMD iptables -t nat -A POSTROUTING -m mark --mark 7368816 -j MASQUERADE && \
accel-pppd -c /etc/accel-ppp.conf ; \
APP_EXIT_CODE="$?" && \
iptables -t nat -D POSTROUTING -m mark --mark 7368816 -j MASQUERADE ; \
exit $APP_EXIT_CODE
