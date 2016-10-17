#!/bin/bash

DOMAINNAME=$1

WANIP=`curl -s http://whatismijnip.nl |cut -d " " -f 5`
PTR=`nslookup $WANIP | grep "name =" | cut -f3 -d" " | rev | cut -c 2- | rev`

debconf-set-selections <<< "postfix postfix/mailname string $DOMAINNAME"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt-get install postfix curl -y
postconf -e myhostname=$PTR
postconf -e inet_protocols=ipv4
postconf -e relay_domains="$DOMAINNAME"
service postfix restart
