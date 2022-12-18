#!/bin/bash

# 서버 초기 셋업 시 수행 할 스크립트

#ASW 방화벽 수동 설정 : TCP: 1723

USER_ACCOUNT=`cat /etc/passwd | grep 1000 | cut -d ':' -f 1`
cd /home/${USER_ACCOUNT}
git clone https://github.com/srkim90/aws-pptp.git
cd /home/${USER_ACCOUNT}/aws-pptp
chmod 755 init.sh
sudo ./init.sh
cd ..
sudo chown -R ${USER_ACCOUNT}:${USER_ACCOUNT} aws-pptp
cd aws-pptp

############################# [안의 내용 수정 할 것]
# [vpn-name] 설절 할 A-Record ex> vpn-mobile5
# [ID] # 반값도매인 계정
# [password] # 반값도매인 비밀번호
# [domain] 관리 도매인 ex> srkim.kr
sudo su ${USER_ACCOUNT} -c 'python3 ./init.py [vpn-name] [password] [domain]'

sudo su ${USER_ACCOUNT} -c 'python3 ./boot.py'