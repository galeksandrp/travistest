PPP_INTERFACE="$1"
PPP_CALLER_IP="$5"

# accel-ppp specific
PPP_CALLER_LOGIN="$PEERNAME"

# Set this to allow responding to traffic from machines behind PPP caller
PPP_ROUTER_LOGIN="router"
PPP_ROUTER_IP="192.168.101.2"

isRouter() {
	# Use either $PPP_CALLER_LOGIN or, if it is not accel-ppp $PPP_CALLER_IP
	[ "$PPP_CALLER_LOGIN" = "$PPP_ROUTER_LOGIN" ]
}
