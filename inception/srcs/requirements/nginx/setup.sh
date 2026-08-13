#!/bin/sh

set -x

openssl req -x509 -nodes \
        -days 90 -newkey rsa:2048 \
        -keyout /etc/ssl/private/hibenouk-nginx-selfsigned.key \
        -out /etc/ssl/certs/hibenouk-nginx-selfsigned.crt -subj "/C=MO/L=KH/O=1337/OU=student/CN=$DOMAIN_NAME"

openssl req -x509 -nodes \
        -days 90 -newkey rsa:2048 \
        -keyout /etc/ssl/private/adminer-nginx-selfsigned.key \
        -out /etc/ssl/certs/adminer-nginx-selfsigned.crt -subj "/C=MO/L=KH/O=1337/OU=student/CN=adminer.me"

openssl req -x509 -nodes \
        -days 90 -newkey rsa:2048 \
        -keyout /etc/ssl/private/cadvisor-nginx-selfsigned.key \
        -out /etc/ssl/certs/cadvisor-nginx-selfsigned.crt -subj "/C=MO/L=KH/O=1337/OU=student/CN=cadvisor.me"

openssl req -x509 -nodes \
        -days 90 -newkey rsa:2048 \
        -keyout /etc/ssl/private/port-nginx-selfsigned.key \
        -out /etc/ssl/certs/port-nginx-selfsigned.crt -subj "/C=MO/L=KH/O=1337/OU=student/CN=hibenouk.1337.me"

chmod -R 755 /var/www/html

exec nginx
