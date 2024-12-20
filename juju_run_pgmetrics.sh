#!/bin/bash

set -e

# V3
function get_unit_ip {
  if [[ -z "$1" ]]; then
    echo "get_unit_ip: unit is not specified" >&2
    exit 1
  fi
  juju show-unit "$1" 2>/dev/null | grep -o " \(public-\)\?address: [0-9.]\+" | cut -d' ' -f3
}

# V3
function get_unit_password {
  if [[ -z "$1" ]]; then
    echo "get_unit_password: unit is not specified" >&2
    exit 1
  fi
  juju run "$1" get-password 2>/dev/null | grep -o "password: [0-9a-zA-Z]\+" | cut -d' ' -f2
}

unit_ip=$(get_unit_ip "$1")
unit_password=$(get_unit_password "$1")

wget https://github.com/rapidloop/pgmetrics/releases/download/v1.17.0/pgmetrics_1.17.0_linux_amd64.tar.gz -nc -nv -P /tmp/
tar -xf /tmp/pgmetrics_1.17.0_linux_amd64.tar.gz -C /tmp/
PGPASSWORD=$unit_password /tmp/pgmetrics_1.17.0_linux_amd64/pgmetrics -U operator -h "$unit_ip" --only-listed postgres
