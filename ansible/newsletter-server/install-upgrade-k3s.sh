#!/usr/bin/env sh

set -eux

curl https://get.k3s.io | \
INSTALL_K3S_CHANNEL=latest \
INSTALL_K3S_EXEC="
--kube-apiserver-arg=service-account-issuer=https://k8s.developer-friendly.blog
--kube-apiserver-arg=service-account-jwks-uri=https://k8s.developer-friendly.blog/openid/v1/jwks
--kube-apiserver-arg=anonymous-auth=true
--cluster-cidr=20.0.0.0/8,2001:cafe:42::/56
--service-cidr=30.0.0.0/12,2001:cafe:43::/112
--disable=traefik
--token-file=/etc/k3s/token
--tls-san=k8s.developer-friendly.blog
--tls-san=128.140.71.149
--tls-san=2a01:4f8:1c1b:68c6::
--disable-network-policy
--flannel-backend none
--secrets-encryption" \
sh -
