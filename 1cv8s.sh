#!/usr/bin/env sh

IBASES_DIRPATH="$HOME/.1C/1cestart"
IBASES_FILEPATH="$IBASES_DIRPATH/ibases.v8i"
NETHASP_FILEPATH=/opt/1cv8/conf/nethasp.ini

appIbases() {
    mkdir -p "$IBASES_DIRPATH"

    env | grep '^APP_SIMPLEIB_' | xargs -i sh -c 'NAME=$(echo {} | cut -d= -f1) \
        && VALUE=$(echo {} | cut -d= -f2) \
        && SRVR=$(echo $VALUE | cut -d# -f1) \
        && REF=$(echo $VALUE | cut -d# -f2) \
        && cat <<- EOF
[$NAME]
Connect=Srvr="$SRVR";Ref="$REF";
EOF' >> "$IBASES_FILEPATH"

    env | grep '^APP_HOSTSIB_' | xargs -i sh -c 'NAME=$(echo {} | cut -d= -f1) \
        && VALUE=$(echo {} | cut -d= -f2) \
        && SRVR=$(echo $VALUE | cut -d# -f1) \
        && REF=$(echo $VALUE | cut -d# -f2) \
        && cat <<- EOF
[$NAME]
Connect=Srvr="$SRVR";Ref="$REF";
EOF' >> "$IBASES_FILEPATH"
}

appHosts() {
    env | grep '^APP_HOSTSIB_' | xargs -i sh -c 'NAME=$(echo {} | cut -d= -f1) \
        && VALUE=$(echo {} | cut -d= -f2) \
        && SERVER_IP=$(echo $VALUE | cut -d# -f1 | cut -d: -f1) \
        && HOSTNAME=$(echo $VALUE | cut -d# -f3) \
        && cat <<- EOF
$SERVER_IP $HOSTNAME
EOF' >> /etc/hosts
}

[ -e "$IBASES_FILEPATH" ] || (appIbases \
	&& ((sleep 5 && killall 1cv8s) &) \
	&& xvfb-run /opt/1cv8/x86_64/${APP_VERSION}/1cv8s)

[ -e "$NETHASP_FILEPATH" ] || cat <<- EOF > "$NETHASP_FILEPATH"
[NH_TCPIP]
NH_SERVER_ADDR = $NH_TCPIP_SERVER_ADDR
EOF

/opt/1cv8/x86_64/${APP_VERSION}/1cv8s \
	&& appHosts

APPPID=$(pidof 1cv8 || pidof 1cv8c) \
    && exec tail --pid=$APPPID -f /dev/null
