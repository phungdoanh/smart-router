#!/bin/sh
#setup usb fs
opkg install kmod-usb2 kmod-usb-storage kmod-fs-ext4 block-mount
mkdir /mnt/sda1
mount /dev/sda2 /mnt/sda1
mkdir -p /tmp/cproot
mount --bind / /tmp/cproot
tar -C /tmp/cproot -cvf - . | tar -C /mnt/sda1 -xf -
umount /tmp/cproot

echo "config mount" >> /etc/config/fstab
echo "        option target        /" >> /etc/config/fstab
echo "        option device        /dev/sda1" >> /etc/config/fstab
echo "        option fstype        ext4" >> /etc/config/fstab
echo "        option options       rw,sync" >> /etc/config/fstab
echo "        option enabled       1" >> /etc/config/fstab
echo "        option enabled_fsck  0" >> /etc/config/fstab

#Ohmyzsh
opkg update
opkg install ca-bundle ca-certificates zsh curl git-http nano
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 
sed -i -- 's/ash/zsh/g' /etc/passwd
sed -i -- 's/robbyrussell/agnoster/g' /root/.zshrc
sed -i "s/prompt_segment blue black '%~'/prompt_segment blue black '%c'/" ~/.oh-my-zsh/themes/agnoster.zsh-theme
source ~/.zshrc

#/etc/config/dhcp DO NOT KNOW IF REALLY NECESSARY
uci set dhcp.lan.dhcp_option='150,192.168.1.1'
uci commit dhcp
/etc/init.d/dnsmasq restart

#Scapy
opkg update
opkg upgrade tar wget
opkg install python tcpdump unzip
wget http://www.secdev.org/projects/scapy/files/scapy-latest.tar.gz
tar -xvf scapy-latest.tar.gz
cd scapy-2.1.0
python setup.py install
cd ..
rm -rf scapy*

#sqlite3 + python3
opkg install sqlite3-cli python-sqlite3 python3 python3-pip python-pip

#pip
pip install --upgrade pip
pip3 install python-dotenv
pip3 install scapy-python3


git clone https://github.com/RUCD/smart-router.git --branch=openwrt
#crontab main.py

#apache
opkg install apache


