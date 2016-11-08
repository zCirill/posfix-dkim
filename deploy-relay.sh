#!/bin/bash

DOMAINNAME=$1

echo $DOMAINNAME relay:$DOMAINNAME >> /etc/postfix/transport
postconf transport_maps=hash:/etc/postfix/transport
postconf mydestination=localhost

postalias /etc/postfix/transport
postfix check && postfix reload




