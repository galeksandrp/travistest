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
RUN sudo -u ng gpg --search-keys galeksandrp || echo 'keyserver keys.openpgp.org' >> /home/ng/.gnupg/gpg.conf

FROM archlinux-yay-toolchain AS archlinux-yay-pkg
RUN sudo -u ng yay -Syu --noconfirm ungoogled-chromium-bin
RUN mkdir /root/pkg
RUN mv /home/ng/.cache/yay/*/ungoogled-chromium-bin-*.pkg* /root/pkg
RUN rm -rf /home/ng/.cache/yay/*/ungoogled-chromium-*.pkg*

# pkg

FROM archlinux-updated
COPY --from=archlinux-yay-pkg /root/pkg /root/pkg
COPY --from=archlinux-yay-pkg /home/ng/.cache/yay/*/*.pkg* /root/pkg/
RUN pacman -U --noconfirm /root/pkg/*.pkg* && rm -rf /var/cache/pacman/pkg
RUN echo '--extension-mime-request-handling=always-prompt-for-install' >> /etc/chromium-flags.conf
CMD ["chromium", "--no-sandbox"]
