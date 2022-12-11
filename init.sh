#!/bin/bash

sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

sudo apt-get -y install software-properties-common
sudo add-apt-repository universe
sudo apt-get -y update
sudo apt-get -y install python3-pip
sudo apt-get -y install unzip
sudo apt-get -y install pptpd
sudo apt-get -y install net-tools

sudo python3 -m pip install marshmallow
sudo python3 -m pip install dataclasses_json

PPTP_CONF="/etc/pptpd.conf"
CHECK="`cat ${PPTP_CONF} | grep -v '#'| grep localip`"
if [ "$CHECK" == "" ]; then
  sudo echo localip 192.168.0.1 >> $PPTP_CONF
  sudo echo remoteip 192.168.0.234-238,192.168.0.245 >> $PPTP_CONF
fi
sudo python3 add_dummy_data.py

SYSCTL_CONF="/etc/sysctl.conf"
CHECK="`cat ${SYSCTL_CONF} | grep -v '#'| grep net.ipv4.ip_forward`"
if [ "$CHECK" == "" ]; then
  sudo echo net.ipv4.ip_forward=1 >> $SYSCTL_CONF
  sudo echo net.ipv4.conf.all.accept_redirects = 0 >> $SYSCTL_CONF
  sudo echo net.ipv4.conf.all.send_redirects = 0 >> $SYSCTL_CONF
  sudo echo net.ipv4.ip_no_pmtu_disc = 1 >> $SYSCTL_CONF
  sudo sysctl -p
fi

OPTION_CONF="/etc/ppp/pptpd-options"
CHECK="`cat ${OPTION_CONF} | grep -v '#'| grep ms_dns`"
if [ "$CHECK" == "" ]; then
  sudo echo ms-dns 8.8.8.8 >> $OPTION_CONF
  sudo echo ms-dns 8.8.4.4 >> $OPTION_CONF
fi

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo service pptpd restart

cd /home/*
cd aws-pptp
chmod 755 reboot.sh
ASW_PATH=`pwd`

RC_LOCAL="/etc/rc.local"
if [ -e $RC_LOCAL ]; then
    echo "$RC_LOCAL File exists."
    CHECK="`cat ${RC_LOCAL} | grep -v '#'| grep reboot`"
    if [ "$CHECK" == "" ]; then
        echo su - pi -c "$ASW_PATH/reboot.sh" >> $RC_LOCAL
    fi
else
  sudo ln -s $ASW_PATH/reboot.sh /etc/init.d/reboot.sh
  sudo ln -s $ASW_PATH/reboot.sh /etc/rc5.d/S02reboot.sh
  sudo update-rc.d reboot.sh defaults
fi