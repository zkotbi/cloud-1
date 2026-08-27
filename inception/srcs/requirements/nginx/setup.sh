#!/bin/sh

set -e

# Check for custom certificates (e.g. worklet.dev.crt or origin.crt)
CUSTOM_CRT=$(find /etc/ssl/custom-certs/ -maxdepth 1 -name "*.crt" | head -n 1)
CUSTOM_KEY=$(find /etc/ssl/custom-certs/ -maxdepth 1 -name "*.key" | head -n 1)

if [ -n "$CUSTOM_CRT" ] && [ -n "$CUSTOM_KEY" ]; then
    echo "Using custom Cloudflare SSL certificates ($CUSTOM_CRT, $CUSTOM_KEY)..."
    cp "$CUSTOM_CRT" /etc/ssl/certs/origin.crt
    cp "$CUSTOM_KEY" /etc/ssl/private/origin.key
    chmod 600 /etc/ssl/private/origin.key
elif [ ! -f /etc/ssl/certs/origin.crt ] || [ ! -f /etc/ssl/private/origin.key ]; then
    echo "No custom SSL certificates found. Generating temporary fallback certificate..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/origin.key \
        -out /etc/ssl/certs/origin.crt \
        -subj "/C=US/ST=State/L=City/O=Inception/CN=${DOMAIN_NAME:-localhost}"
fi

chmod -R 755 /var/www/html

exec nginx
