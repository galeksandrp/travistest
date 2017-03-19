FROM pritunl/archlinux
RUN pacman -S --needed base-devel --noconfirm
RUN useradd ng -m
USER ng
CMD ["makepkg"]
