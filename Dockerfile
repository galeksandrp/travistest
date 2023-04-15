FROM archlinux AS archlinux-updated
RUN pacman -Syu --noconfirm && rm -rf /var/cache/pacman/pkg

FROM archlinux-updated AS archlinux-sudo
RUN pacman -Syu --noconfirm sudo && rm -rf /var/cache/pacman/pkg
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/wheel

# ng

FROM archlinux-sudo AS archlinux-ng
RUN useradd -G wheel -m ng
WORKDIR /home/ng

FROM archlinux-ng AS archlinux-ng-toolchain
RUN pacman -Syu --noconfirm base-devel && rm -rf /var/cache/pacman/pkg

# yay

FROM archlinux-ng-toolchain AS archlinux-yay-toolchain
RUN pacman -Syu --noconfirm git && rm -rf /var/cache/pacman/pkg
RUN sudo -u ng git clone https://aur.archlinux.org/yay.git
WORKDIR /home/ng/yay
RUN sudo -u ng makepkg -si --noconfirm
RUN sudo -u ng gpg --search-keys galeksandrp || echo 'keyserver keys.gnupg.net' >> /home/ng/.gnupg/gpg.conf

FROM archlinux-yay-toolchain AS archlinux-yay-pkg
RUN sudo -u ng yay -Syu --noconfirm freenet

# pkg

FROM archlinux-updated AS archlinux-freenet
COPY --from=archlinux-yay-pkg /home/ng/.cache/yay/*/*.pkg* /root/pkg/
RUN pacman -U --noconfirm /root/pkg/*.pkg* && rm -rf /var/cache/pacman/pkg

# freenet

FROM archlinux-freenet

RUN ((sleep 30 && freenet stop) &) && freenet console

RUN rm -rf /opt/freenet/plugins/WebOfTrust.jar
RUN curl -L --output /opt/freenet/plugins/UPnP.jar https://github.com/galeksandrp/plugin-UPnP/releases/download/10007/UPnP.jar

RUN sed -i -e 's/^fproxy.bindTo=.*/fproxy.bindTo=0.0.0.0/' \
  -e 's/^fproxy.allowedHosts=.*/fproxy.allowedHosts=*/' \
  -e 's/^fproxy.allowedHostsFullAccess=.*/fproxy.allowedHostsFullAccess=*/' \
  -e 's/^pluginmanager.loadplugin=WebOfTrust/pluginmanager.loadplugin=UPnP/' /opt/freenet/conf/freenet.ini

RUN ((sleep 30 && freenet stop) &) && freenet console

CMD ["freenet", "console"]
