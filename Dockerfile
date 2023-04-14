FROM archlinux AS archlinux-updated
RUN pacman -Syu --noconfirm

FROM archlinux-updated AS archlinux-sudo
RUN pacman -Syu --noconfirm sudo
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

# ng

FROM archlinux-sudo AS archlinux-ng
RUN useradd -G wheel -m ng
WORKDIR /home/ng

FROM archlinux-ng AS archlinux-ng-toolchain
RUN pacman -Syu --noconfirm base-devel

# pkg

FROM archlinux-ng-toolchain AS archlinux-pkg
RUN pacman -Syu --noconfirm git

RUN sudo -u ng git clone https://aur.archlinux.org/xidel.git xidel
WORKDIR /home/ng/xidel
RUN sudo -u ng makepkg -s --noconfirm
WORKDIR /home/ng

RUN sudo -u ng gpg --recv-keys 0E51E7F06EF719FBD072782A5F56E5AFA63CCD33
RUN sudo -u ng git clone -b packages/icu --depth=50 https://github.com/archlinux/svntogit-packages.git icu
WORKDIR /home/ng/icu/trunk
RUN sudo -u ng git checkout 5709c1a0a314d08a3318b4074eccd480889e7fdd
RUN sudo -u ng makepkg -s --noconfirm

# app download

FROM archlinux-updated AS archlinux-download
COPY --from=archlinux-pkg /home/ng/xidel/*.pkg* /root/pkg/xidel/
RUN pacman -U --noconfirm /root/pkg/xidel/*.pkg*
WORKDIR /root/pkg/ungoogled-chromium-bin
RUN curl -OLJ $(xidel $(xidel https://ungoogled-software.github.io/ungoogled-chromium-binaries/feed.xml -e '//entry[id[ends-with(., "ArchLinux")]]/link/@href') -e '//a[contains(@href, ".pkg.tar")]/@href')

# app

FROM archlinux-updated
COPY --from=archlinux-pkg /home/ng/icu/trunk/*.pkg* /root/pkg/
COPY --from=archlinux-download /root/pkg/ungoogled-chromium-bin/*.pkg* /root/pkg/
RUN pacman -U --noconfirm /root/pkg/*.pkg*
