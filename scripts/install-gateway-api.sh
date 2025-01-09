#!/usr/bin/env bash

set -eu

kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml \
-f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/experimental-install.yaml --server-side
