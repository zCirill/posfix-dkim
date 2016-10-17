#!/bin/bash

DOMAINNAME=$1

apt-get update
apt-get install opendkim opendkim-tools -y
echo $DOMAINNAME >> /etc/dkim.domains
mkdir /etc/opendkim

opendkim-genkey --directory=/etc/opendkim/ --domain=name=$DOMAINNAME --selector=email

cp email.* /etc/opendkim/
cp conf/dkim/opendkim.conf /etc/opendkim.conf
echo "email._domainkey.$DOMAINNAME $DOMAINNAME:email:/etc/opendkim/email.private" > /etc/opendkim/keytable
echo "$DOMAINNAME email._domainkey.$DOMAINNAME" >> /etc/opendkim/signingtable
chown opendkim.opendkim /etc/opendkim/*
chmod 600 -R /etc/opendkim/*
gpasswd -a postfix opendkim
postconf -e milter_default_action=accept
postconf -e milter_protocol=2
postconf -e smtpd_milters=inet:localhost:8891
postconf -e non_smtpd_milters=inet:localhost:8891
echo "SOCKET=inet:8891@localhost" >> /etc/default/opendkim

/etc/init.d/opendkim restart
/etc/init.d/postfix restart

