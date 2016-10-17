#!/bin/bash

DOMAINNAME=$1

debconf-set-selections <<< "postfix postfix/mailname string $DOMAINNAME"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt-get install postfix -y
postconf -e myhostname=email.$DOMAINNAME
postconf -e inet_protocols=ipv4
postconf -e relay_domains="$DOMAINNAME"
service postfix restart
