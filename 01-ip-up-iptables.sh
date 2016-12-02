#!/usr/bin/env bash
echo "$PPP_INTERFACE ip-pre-up"
iptables -t mangle -A FORWARD -i $IFNAME -j MARK --set-mark 7368816
iptables -t filter -A FORWARD -i $IFNAME -j ACCEPT
