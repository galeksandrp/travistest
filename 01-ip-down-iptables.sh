#!/usr/bin/env bash
echo "$PPP_INTERFACE ip-down"
iptables -t mangle -D FORWARD -i $IFNAME -j MARK --set-mark 7368816
iptables -t filter -D FORWARD -i $IFNAME -j ACCEPT
