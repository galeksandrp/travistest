FROM fedora:25
RUN dnf -y install fedora-packager
RUN useradd ng -m
RUN usermod -a -G mock ng
USER ng
CMD spectool -g *spec && fedpkg --release f25 local
