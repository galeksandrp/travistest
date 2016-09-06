var irc = require('irc');
var client = new irc.Client('chat.freenode.net', 'travis'+process.argv[2], {
	port: 6697,
	secure: true,
	channels: ['#travis'+process.argv[2]]
});
var ips = {};
client.addListener('pm', function (from, message) {
	ips[message] = 1;
	if (Object.keys(ips).length === parseInt(process.argv[3])) {
		console.log('localhost,lzo,cpp '+Object.keys(ips).join(',lzo,cpp ')+',lzo,cpp');
		process.exit(0);
	}
});
