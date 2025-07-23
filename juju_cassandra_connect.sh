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

# V4
function get_unit_password {
  if [[ -z "$1" ]]; then
    echo "get_unit_password: unit is not specified" >&2
    exit 1
  fi
  application=$(echo "$1" | cut -d "/" -f 1)
  juju show-secret --reveal "cassandra-peers.$application.app" --format json | jq -r '.[].content.Data."cassandra-password"'
}

unit_ip=$(get_unit_ip "$1")
unit_password=$(get_unit_password "$1")

juju ssh "$1" charmed-cassandra.cqlsh "$unit_ip" -ucassandra "-p$unit_password"
