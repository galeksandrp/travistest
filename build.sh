#!/usr/bin/env bash
set -e
service miredo start
apt-get update
service ssh start
TERM=xterm watch -n 5 ip addr