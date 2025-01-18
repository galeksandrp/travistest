#!/usr/bin/env sh

env | grep '^FRP_PROXYHTTP_.*_NAME=' | xargs -i sh -c 'SLUG=$(echo {} | sed "s/_NAME=.*$//") \
    && cat <<- EOF
[[proxies]]
name = "{{ .Envs.${SLUG}_NAME }}"
type = "http"
localIP = "{{ .Envs.${SLUG}_LOCAL_IP }}"
localPort = {{ .Envs.${SLUG}_LOCAL_PORT }}
customDomains = ["{{ .Envs.${SLUG}_CUSTOM_DOMAINS }}"]
EOF' >> ./frpc.toml

env | grep '^FRP_SIMPLEHTTP_' | xargs -i sh -c 'NAME=$(echo {} | cut -d= -f1) \
    && VALUE=$(echo {} | cut -d= -f2) \
    && LOCAL_IP=$(echo $VALUE | cut -d: -f1) \
    && LOCAL_PORT=$(echo $VALUE | cut -d: -f2) \
    && CUSTOM_DOMAINS=$(echo $VALUE | cut -d: -f3) \
    && cat <<- EOF
[[proxies]]
name = "$NAME"
type = "http"
localPort = $LOCAL_PORT
localIP = "$LOCAL_IP"
customDomains = ["$CUSTOM_DOMAINS"]
EOF' >> ./frpc.toml

env | grep '^FRP_SIMPLEHTTPS2HTTP_' | xargs -i sh -c 'NAME=$(echo {} | cut -d= -f1) \
    && VALUE=$(echo {} | cut -d= -f2) \
    && LOCAL_IP=$(echo $VALUE | cut -d: -f1) \
    && LOCAL_PORT=$(echo $VALUE | cut -d: -f2) \
    && CUSTOM_DOMAINS=$(echo $VALUE | cut -d: -f3) \
    && CRTSLUG=$(echo $VALUE | cut -d: -f4) \
    && cat <<- EOF
[[proxies]]
name = "$NAME"
type = "https"
customDomains = ["$CUSTOM_DOMAINS"]
[proxies.plugin]
type = "https2http"
localAddr = "$LOCAL_IP:$LOCAL_PORT"
crtPath = "/etc/letsencrypt/live/$CRTSLUG/fullchain.pem"
keyPath = "/etc/letsencrypt/live/$CRTSLUG/privkey.pem"
EOF' >> ./frpc.toml

env | grep '^FRP_SIMPLEHTTPS2HTTPS_' | xargs -i sh -c 'NAME=$(echo {} | cut -d= -f1) \
    && VALUE=$(echo {} | cut -d= -f2) \
    && LOCAL_IP=$(echo $VALUE | cut -d: -f1) \
    && LOCAL_PORT=$(echo $VALUE | cut -d: -f2) \
    && CUSTOM_DOMAINS=$(echo $VALUE | cut -d: -f3) \
    && CRTSLUG=$(echo $VALUE | cut -d: -f4) \
    && cat <<- EOF
[[proxies]]
name = "$NAME"
type = "https"
customDomains = ["$CUSTOM_DOMAINS"]
[proxies.plugin]
type = "https2https"
localAddr = "$LOCAL_IP:$LOCAL_PORT"
crtPath = "/etc/letsencrypt/live/$CRTSLUG/fullchain.pem"
keyPath = "/etc/letsencrypt/live/$CRTSLUG/privkey.pem"
EOF' >> ./frpc.toml

env | grep '^FRP_HOSTHTTPS2HTTPS_' | xargs -i sh -c 'NAME=$(echo {} | cut -d= -f1) \
    && VALUE=$(echo {} | cut -d= -f2) \
    && LOCAL_IP=$(echo $VALUE | cut -d: -f1) \
    && LOCAL_PORT=$(echo $VALUE | cut -d: -f2) \
    && CUSTOM_DOMAINS=$(echo $VALUE | cut -d: -f3) \
    && CRTSLUG=$(echo $VALUE | cut -d: -f4) \
    && cat <<- EOF
[[proxies]]
name = "$NAME"
type = "https"
customDomains = ["$CUSTOM_DOMAINS"]
[proxies.plugin]
type = "https2https"
localAddr = "$LOCAL_IP:$LOCAL_PORT"
crtPath = "/etc/letsencrypt/live/$CRTSLUG/fullchain.pem"
keyPath = "/etc/letsencrypt/live/$CRTSLUG/privkey.pem"
hostHeaderRewrite = "$LOCAL_IP"
EOF' >> ./frpc.toml

env | grep '^FRP_HOSTHRHTTPS2HTTP_' | xargs -i sh -c 'NAME=$(echo {} | cut -d= -f1) \
    && VALUE=$(echo {} | cut -d= -f2) \
    && LOCAL_IP=$(echo $VALUE | cut -d: -f1) \
    && LOCAL_PORT=$(echo $VALUE | cut -d: -f2) \
    && CUSTOM_DOMAINS=$(echo $VALUE | cut -d: -f3) \
    && CRTSLUG=$(echo $VALUE | cut -d: -f4) \
    && HOSTHR=$(echo $VALUE | cut -d: -f5) \
    && cat <<- EOF
[[proxies]]
name = "$NAME"
type = "https"
customDomains = ["$CUSTOM_DOMAINS"]
[proxies.plugin]
type = "https2http"
localAddr = "$LOCAL_IP:$LOCAL_PORT"
crtPath = "/etc/letsencrypt/live/$CRTSLUG/fullchain.pem"
keyPath = "/etc/letsencrypt/live/$CRTSLUG/privkey.pem"
hostHeaderRewrite = "$HOSTHR"
EOF' >> ./frpc.toml

env | grep '^FRP_HOSTHRHTTPS2HTTPS_' | xargs -i sh -c 'NAME=$(echo {} | cut -d= -f1) \
    && VALUE=$(echo {} | cut -d= -f2) \
    && LOCAL_IP=$(echo $VALUE | cut -d: -f1) \
    && LOCAL_PORT=$(echo $VALUE | cut -d: -f2) \
    && CUSTOM_DOMAINS=$(echo $VALUE | cut -d: -f3) \
    && CRTSLUG=$(echo $VALUE | cut -d: -f4) \
    && HOSTHR=$(echo $VALUE | cut -d: -f5) \
    && cat <<- EOF
[[proxies]]
name = "$NAME"
type = "https"
customDomains = ["$CUSTOM_DOMAINS"]
[proxies.plugin]
type = "https2https"
localAddr = "$LOCAL_IP:$LOCAL_PORT"
crtPath = "/etc/letsencrypt/live/$CRTSLUG/fullchain.pem"
keyPath = "/etc/letsencrypt/live/$CRTSLUG/privkey.pem"
hostHeaderRewrite = "$HOSTHR"
EOF' >> ./frpc.toml

cat ./frpc.toml

exec /usr/bin/frpc -c ./frpc.toml "$@"
