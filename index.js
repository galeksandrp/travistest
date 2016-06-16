var SteamTotp = require('steam-totp');
console.log(SteamTotp.generateAuthCode(process.argv[2]));
