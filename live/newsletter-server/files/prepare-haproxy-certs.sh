#!/bin/bash
set -e

certbot renew -q || echo "Certbot not renewed!"

cd /etc/letsencrypt/live/developer-friendly.blog

temp_cert=$(mktemp)

cat fullchain.pem privkey.pem > "$temp_cert"

if ! cmp -s "$temp_cert" /etc/haproxy/certs/developer-friendly.blog; then
    mv "$temp_cert" /etc/haproxy/certs/developer-friendly.blog
    systemctl reload haproxy
    echo "Certificate updated and HAProxy reloaded."
else
    echo "Certificate unchanged. No reload necessary."
fi

rm -f "$temp_cert"
