sudo yum install debootstrap
mkdir chroot-trusty
sudo mkdir /usr/share/keyrings
sudo wget http://archive.ubuntu.com/ubuntu/project/ubuntu-archive-keyring.gpg -O /usr/share/keyrings/ubuntu-archive-keyring.gpg
sudo debootstrap trusty chroot-trusty
snap_shell
