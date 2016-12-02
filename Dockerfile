FROM archlinux AS archlinux-updated
RUN pacman -Syu --noconfirm
FROM archlinux-updated AS archlinux-yay-toolchain
RUN pacman -S --noconfirm base-devel git
RUN sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
RUN grep '^%wheel ALL=(ALL) NOPASSWD: ALL' /etc/sudoers || echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN useradd -G wheel -m ng
USER ng
WORKDIR /home/ng
RUN git clone https://aur.archlinux.org/yay.git
RUN cd yay && makepkg -s --noconfirm
FROM archlinux-updated
COPY --from=archlinux-yay-toolchain /home/ng/yay/*.pkg.* /root/
RUN pacman -U --noconfirm /root/*.pkg.*
