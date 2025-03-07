#!/bin/bash

set -e

if [[ -z "$2" ]]; then
  echo "candidate unit is not specified" >&2
  exit 1
fi

# V3
function get_unit_ip {
  if [[ -z "$1" ]]; then
    echo "get_unit_ip: unit is not specified" >&2
    exit 1
  fi
  juju show-unit "$1" 2>/dev/null | grep -o " \(public-\)\?address: [0-9.]\+" | cut -d' ' -f3
}

# V3 (modified)
function get_unit_password {
  if [[ -z "$1" ]]; then
    echo "get_unit_password: unit is not specified" >&2
    exit 1
  fi
  juju run "$1" get-password username=patroni 2>/dev/null | grep -o "password: [0-9a-zA-Z]\+" | cut -d' ' -f2
}

# V1
function get_patroni_unit_name {
  if [[ -z "$1" ]]; then
    echo "get_patroni_unit_name: unit is not specified" >&2
    exit 1
  fi
  unit=$1
  echo "${unit//\//-}"
}

leader_ip=$(get_unit_ip "$1")
patroni_password=$(get_unit_password "$1")
leader_name=$(get_patroni_unit_name "$1")
candidate_name=$(get_patroni_unit_name "$2")

curl -u "patroni:$patroni_password" -X POST -d "{\"leader\": \"$leader_name\", \"candidate\": \"$candidate_name\"}" -H "Content-Type: application/json" "http://$leader_ip:8008/switchover"