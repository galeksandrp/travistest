FROM base/devel
RUN useradd ng -m
USER ng
CMD ["makepkg"]
