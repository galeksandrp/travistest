echo $PUBLIC_KEY >> ~/.ssh/authorized_keys
curl -X POST "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE/dns_records" -H "X-Auth-Email: $EMAIL" -H "X-Auth-Key: $CLOUDFLARE_KEY" -H "Content-Type: application/json" --data "{\"type\": \"A\",\"name\": \"$TRAVIS_BUILD_ID.build.gap.pp.ua\",\"content\": \"$(hostname -I | cut -d ' ' -f 1)\"}"
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
./ngrok authtoken $NG
./ngrok tcp 22 > /dev/null &
