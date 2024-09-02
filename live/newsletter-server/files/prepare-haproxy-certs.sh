#!/bin/bash
set -e

certbot renew || echo "Certbot not renewed!"

cd /etc/letsencrypt/live/newsletter.developer-friendly.blog

cat fullchain.pem privkey.pem > /etc/haproxy/certs/newsletter.developer-friendly.blog.pem

systemctl reload haproxy
