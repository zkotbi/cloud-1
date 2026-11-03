#!/bin/sh

set -e

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/origin.key \
    -out /etc/ssl/certs/origin.crt \
    -subj "/C=US/ST=State/L=City/O=Inception/CN=$DOMAIN_NAME"

chmod -R 755 /var/www/html

exec nginx