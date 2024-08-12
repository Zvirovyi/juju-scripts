#!/bin/bash

set -e

# V2
function get_unit_ip {
    echo $(juju show-unit $1 2>/dev/null | grep -o " \(public-\)\?address: [0-9.]\+" | cut -d' ' -f3)
}

# V2
function get_unit_password {
    echo $(juju run $1 get-password 2>/dev/null | grep -o "password: [0-9a-zA-Z]\+" | cut -d' ' -f2)
}

wget https://github.com/rapidloop/pgmetrics/releases/download/v1.17.0/pgmetrics_1.17.0_linux_amd64.tar.gz -nc -nv -P /tmp/
tar -xf /tmp/pgmetrics_1.17.0_linux_amd64.tar.gz -C /tmp/
PGPASSWORD=$(get_unit_password $1) /tmp/pgmetrics_1.17.0_linux_amd64/pgmetrics -U operator -h $(get_unit_ip $1) --only-listed postgres
