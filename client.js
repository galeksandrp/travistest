var irc = require('irc');
var os = require('os');
var client = new irc.Client('chat.freenode.net', 'travis'+process.argv[3], {
	port: 6697,
	secure: true,
	channels: ['#travis'+process.argv[2]]
});
os.networkInterfaces().eth0.forEach(function (iface) {
	if ('IPv4' === iface.family && iface.internal === false) {
		client.addListener('join#travis'+process.argv[2], function (from, message) {
			if (from ==='travis'+process.argv[2]) client.say('travis'+process.argv[2], iface.address);
		});
		client.addListener('registered', function (message) {
			client.say('travis'+process.argv[2], iface.address);
		});
	}
});
