#!/usr/bin/env sh

set -eux

cilium upgrade \
  --set kubeProxyReplacement=true \
  --set gatewayAPI.enabled=true \
  --set encryption.enabled=true \
  --set encryption.type=wireguard \
  --set hubble.enabled=true \
  --set hubble.ui.enabled=true \
  --set hubble.relay.enabled=true \
  --version=1.16.5 \
  --wait
