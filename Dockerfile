FROM fatedier/frpc:v0.65.0

COPY frpc.toml frpc.toml
COPY frpc.sh frpc.sh

ENTRYPOINT [""]
CMD ["./frpc.sh"]
