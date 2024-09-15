#!/usr/bin/env sh

set -eu

curl --compressed https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt 2>/dev/null | \
  grep -v "#" | \
  grep -v -E "\s[1-2]$" | \
  cut -f 1 | \
  sort -n > /etc/haproxy/bad_reputation_ips.lst

count=$(wc -l /etc/haproxy/bad_reputation_ips.lst | cut -d ' ' -f 1)

echo "Total number of blocked IP addresses: $count"
