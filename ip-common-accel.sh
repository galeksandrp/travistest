PPP_INTERFACE="$1"
PPP_MARK="1$(echo $PPP_INTERFACE | grep -o '[0-9]\+')"
PPP_CALLER_IP="$5"

# accel-ppp specific
#PPP_CALLER_LOGIN="$PEERNAME"

# Set this to allow responding to traffic from machines behind PPP caller
#PPP_ROUTER_LOGIN="router"
PPP_ROUTER_IP="192.168.101.2"

PPP_SCRIPT_NAME="$0"

pppLog() {
	FUNCTION_NAME="$1"
	
	echo "$PPP_SCRIPT_NAME -> $FUNCTION_NAME"
}

pppIsRouter() {
	# Use either $PPP_CALLER_LOGIN or, if it is not accel-ppp $PPP_CALLER_IP
	[ "$PPP_CALLER_IP" = "$PPP_ROUTER_IP" ]
}

pppIPTablesRules() {
	pppLog ${FUNCNAME[0]}

	iptables -t mangle -$IPTABLES_COMMAND FORWARD -i $PPP_INTERFACE -j MARK --set-mark $PPP_MARK
	iptables -t nat -$IPTABLES_COMMAND POSTROUTING -o $PPP_DEFAULT_INTERFACE -m mark --mark $PPP_MARK -j MASQUERADE

	# To enable traffic to machines behind PPP caller, you need to do something like that on PPP caller (xl2tpd-1.3.7 example)
	# echo -e '#!/usr/bin/env bash\niptables -t filter -A FORWARD -i $PPP_IFACE -j ACCEPT' > /etc/ppp/ip-up.d/iptables-filter-forward-ppp-iface-accept
	# echo -e '#!/usr/bin/env bash\niptables -t filter -D FORWARD -i $PPP_IFACE -j ACCEPT' > /etc/ppp/ip-down.d/iptables-filter-forward-ppp-iface-accept
	# chmod +x /etc/ppp/ip-up.d/iptables-filter-forward-ppp-iface-accept
	# chmod +x /etc/ppp/ip-down.d/iptables-filter-forward-ppp-iface-accept
	iptables -t filter -$IPTABLES_COMMAND FORWARD -i $PPP_INTERFACE -j ACCEPT
	# Some setups does not allow traffic to PPP tunnel by default
	iptables -t filter -$IPTABLES_COMMAND FORWARD -o $PPP_INTERFACE -j ACCEPT

	# To enable traffic to MiniUPnPD forwarded ports
	# echo -e '#!/usr/bin/env bash\niptables -t nat -A PREROUTING -i $PPP_IFACE -j MINIUPNPD\niptables -t nat -A POSTROUTING -o $PPP_IFACE -j MINIUPNPD-POSTROUTING' > /etc/ppp/ip-up.d/iptables-nat-miniupnpd
	# echo -e '#!/usr/bin/env bash\niptables -t nat -D PREROUTING -i $PPP_IFACE -j MINIUPNPD\niptables -t nat -D POSTROUTING -o $PPP_IFACE -j MINIUPNPD-POSTROUTING' > /etc/ppp/ip-down.d/iptables-nat-miniupnpd
	# chmod +x /etc/ppp/ip-up.d/iptables-nat-miniupnpd
	# chmod +x /etc/ppp/ip-down.d/iptables-nat-miniupnpd
	if pppIsRouter; then
		# icmp
		iptables -t nat -$IPTABLES_COMMAND PREROUTING -i $PPP_DEFAULT_INTERFACE -p 1 -d $PPP_DEFAULT_INTERFACE_IP -j RETURN

		# ssh
		iptables -t nat -$IPTABLES_COMMAND PREROUTING -i $PPP_DEFAULT_INTERFACE -p tcp -d $PPP_DEFAULT_INTERFACE_IP --dport 22 -j RETURN
		iptables -t nat -$IPTABLES_COMMAND PREROUTING -i $PPP_DEFAULT_INTERFACE -p udp -d $PPP_DEFAULT_INTERFACE_IP --dport 22 -j RETURN

		# l2tp
		iptables -t nat -$IPTABLES_COMMAND PREROUTING -i $PPP_DEFAULT_INTERFACE -p tcp -d $PPP_DEFAULT_INTERFACE_IP --dport 1701 -j RETURN
		iptables -t nat -$IPTABLES_COMMAND PREROUTING -i $PPP_DEFAULT_INTERFACE -p udp -d $PPP_DEFAULT_INTERFACE_IP --dport 1701 -j RETURN

		# wireguard
		iptables -t nat -$IPTABLES_COMMAND PREROUTING -i $PPP_DEFAULT_INTERFACE -p tcp -d $PPP_DEFAULT_INTERFACE_IP --dport 51820 -j RETURN
		iptables -t nat -$IPTABLES_COMMAND PREROUTING -i $PPP_DEFAULT_INTERFACE -p udp -d $PPP_DEFAULT_INTERFACE_IP --dport 51820 -j RETURN

		# pptp
		iptables -t nat -$IPTABLES_COMMAND PREROUTING -i $PPP_DEFAULT_INTERFACE -p tcp -d $PPP_DEFAULT_INTERFACE_IP --dport 1723 -j RETURN
		iptables -t nat -$IPTABLES_COMMAND PREROUTING -i $PPP_DEFAULT_INTERFACE -p udp -d $PPP_DEFAULT_INTERFACE_IP --dport 1723 -j RETURN

		# pptp gre
		iptables -t nat -$IPTABLES_COMMAND PREROUTING -i $PPP_DEFAULT_INTERFACE -p 47 -d $PPP_DEFAULT_INTERFACE_IP -j RETURN

		iptables -t nat -$IPTABLES_COMMAND PREROUTING -i $PPP_DEFAULT_INTERFACE -d $PPP_DEFAULT_INTERFACE_IP -j DNAT --to-destination $PPP_CALLER_IP
	fi

	# To enable port forwarding to tunnel on Wive-RTNL
	# echo -e '#!/usr/bin/env bash\n/etc/portforward_vpn A $PPP_IFACE $PPP_LOCAL' > /etc/ppp/ip-up.d/iptables-nat-portforward
	# echo -e '#!/usr/bin/env bash\n/etc/portforward_vpn D $PPP_IFACE $PPP_LOCAL' > /etc/ppp/ip-down.d/iptables-nat-portforward
	# chmod +x /etc/ppp/ip-up.d/iptables-nat-portforward
	# chmod +x /etc/ppp/ip-down.d/iptables-nat-portforward
}

pppRoutes() {
	pppLog ${FUNCNAME[0]}

	if pppIsRouter; then
		# Subnet of 192.168.0.0/16 is used by PPP callers
		# and subnet of 172.16.0.0/12 is used by containers.

		# On Windows WSL2 you need more finely sliced subnets
		# since additional subnet of 192.168.0.0/16 is used by containers on that platform (as of 2020-11-22).
		ip route $ROUTES_COMMAND 10.0.0.0/8 dev $PPP_INTERFACE
	fi
}

pppLog $BASH_SOURCE
