#!/usr/bin/env bash
. /etc/ppp/ip-common-accel.sh

echo "PPP_DEFAULT_INTERFACE='$(ip -4 -j route get 255.255.255.255 | jq -r '.[].dev')'
PPP_DEFAULT_INTERFACE_IP='$(ip -4 -j route get 255.255.255.255 | jq -r '.[].prefsrc')'" > ~/ppp_environment_$PPP_INTERFACE

. ~/ppp_environment_$PPP_INTERFACE

IPTABLES_COMMAND='A' pppIPTablesRules

ROUTES_COMMAND='add' pppRoutes
