#!/bin/bash
set -euo pipefail
exec > /var/log/bootstrap.log 2>&1

apt-get update -y
apt-get install -y curl ca-certificates
curl -sfL https://get.k3s.io | sh -s - server --disable traefik
