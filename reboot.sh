#!/bin/bash

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo service pptpd restart


cd /home/*
cd aws-pptp
USER=`cat /etc/passwd | grep 1000 | cut -d ':' -f 1`
sudo su $USER -c 'python3 ./boot.py'