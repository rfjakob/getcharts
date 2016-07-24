#!/bin/bash -eu

# Masquerade wget as Chrome 51 on Windows 7
wget \
  --header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" \
  --header="Accept-Encoding: gzip, deflate, sdch" \
  --header="Accept-Language: de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4" \
  --header="Upgrade-Insecure-Requests: 1" \
  --header="User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" \
  -q -O /dev/null \
  $1
