#!/bin/bash

set -e

function get_unit_ip {
    echo $(juju show-unit $1 2>/dev/null | grep -o " \(public-\)\?address: [0-9.]\+" | cut -d' ' -f3)
}

function get_unit_password {
    echo $(juju run $1 get-password 2>/dev/null | grep -o "password: [0-9a-zA-Z]\+" | cut -d' ' -f2)
}

PGPASSWORD=$(get_unit_password $1) psql -U operator -d postgres -h $(get_unit_ip $1)
