#!/bin/bash

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo service pptpd restart
cd /home/ubuntu/aws-pptp
sudo su ubuntu -c 'python3 ./boot.py'