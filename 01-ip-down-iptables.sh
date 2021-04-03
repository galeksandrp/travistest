#!/usr/bin/env bash
. /etc/ppp/ip-common-accel.sh

. ~/ppp_environment_$PPP_INTERFACE

rm -f ~/ppp_environment_$PPP_INTERFACE

IPTABLES_COMMAND='D' pppIPTablesRules

ROUTES_COMMAND='delete' pppRoutes
