#!/bin/bash

DOMAINNAME=$1


debconf-set-selections <<< "postfix postfix/mailname string $DOMAINNAME"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt-get install postfix curl -y

WANIP=`curl -s http://whatismijnip.nl |cut -d " " -f 5`
PTR=`nslookup $WANIP | grep "name =" | cut -f3 -d" " | rev | cut -c 2- | rev`

postconf -e myhostname=$PTR
postconf -e inet_protocols=ipv4
postconf -e relay_domains="$DOMAINNAME"
postconf -e smtp_tls_security_level=may
postconf -e smtp_tls_ciphers=export
postconf -e smtp_tls_protocols='!SSLv2, !SSLv3'
postconf -e smtp_tls_loglevel=1

service postfix restart
