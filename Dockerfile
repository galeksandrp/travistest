FROM archlinux
RUN pacman -Syu --noconfirm && pacman -S --noconfirm base-devel
RUN sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
RUN grep '^%wheel ALL=(ALL) NOPASSWD: ALL' /etc/sudoers || echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN useradd -G wheel -m ng
USER ng
CMD ["makepkg"]
