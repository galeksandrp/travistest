FROM fatedier/frps:v0.65.0

ENTRYPOINT [""]
CMD ["sh", "-c", "exec /usr/bin/frps \
    --dashboard-port 7001 \
    --dashboard-pwd $FRP_DASHBOARD_PWD \
    --token $FRP_AUTH_TOKEN \
    --vhost-http-port 80 \
    --vhost-https-port 443"]
