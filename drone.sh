sudo passwd -d $(whoami)
sudo passwd -d root
echo $PUBLIC_KEY >> ~/.ssh/authorized_keys
echo $PUBLIC_KEY | sudo tee /root/.ssh/authorized_keys
sudo adduser --disabled-password --gecos '' ng
sudo -u ng -i wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
sudo -u ng -i unzip ngrok-stable-linux-amd64.zip
sudo -u ng -i ./ngrok authtoken $NG
sudo -u ng -i ./ngrok tcp 22 > /dev/null &
export TERM=xterm
watch -n 540 echo 'LOL'
