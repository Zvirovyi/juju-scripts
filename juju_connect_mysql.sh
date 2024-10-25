#!/bin/bash

set -e

# V2
function get_unit_password {
    echo $(juju run $1 get-password 2>/dev/null | grep -o "password: [0-9a-zA-Z]\+" | cut -d' ' -f2)
}

juju ssh $1 mysql -h 127.0.0.1 -uroot -p$(get_unit_password $1)
