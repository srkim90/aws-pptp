#!/bin/bash

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo service pptpd restart


cd /home/*
cd aws-pptp
USER=`cat /etc/passwd | grep 1000 | cut -d ':' -f 1`
sleep 10
sudo su $USER -c 'python3 ./boot.py'
date >> ~/log.txt
id >> ~/log.txt
echo "------------------------------------" >> ~/log.txt