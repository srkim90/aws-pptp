#!/bin/bash

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo service pptpd restart