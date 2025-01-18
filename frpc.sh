#!/usr/bin/env sh

env | grep '^FRP_PROXYHTTP_.*_NAME=' | xargs -i sh -c 'NAME=$(echo {} | sed "s/_NAME=.*$//") \
    && cat <<- EOF
[[proxies]]
name = "{{ .Envs.${NAME}_NAME }}"
type = "http"
localIP = "{{ .Envs.${NAME}_LOCAL_IP }}"
localPort = {{ .Envs.${NAME}_LOCAL_PORT }}
customDomains = ["{{ .Envs.${NAME}_CUSTOM_DOMAINS }}"]
EOF' >> ./frpc.toml

env | grep 'FRP_SIMPLEHTTP_' | xargs -i sh -c 'NAME=$(echo {} | cut -d= -f1) \
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

cat ./frpc.toml

exec /usr/bin/frpc -c ./frpc.toml "$@"
