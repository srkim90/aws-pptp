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
  sudo sysctl -p
fi

OPTION_CONF="/etc/ppp/pptpd-options"
CHECK="`cat ${OPTION_CONF} | grep -v '#'| grep ms_dns`"
if [ "$CHECK" == "" ]; then
  sudo echo ms-dns 8.8.8.8 >> $OPTION_CONF
  sudo echo ms-dns 8.8.4.4 >> $OPTION_CONF
fi

/bin/bash reboot.sh