#!/bin/bash

set -e

# V2
function get_unit_ip {
    echo $(juju show-unit $1 2>/dev/null | grep -o " \(public-\)\?address: [0-9.]\+" | cut -d' ' -f3)
}

# V2
function get_unit_password {
    echo $(juju run $1 get-password username=clusteradmin 2>/dev/null | grep -o "password: [0-9a-zA-Z]\+" | cut -d' ' -f2)
}

mysql -h $(get_unit_ip $1) -uclusteradmin -p$(get_unit_password $1)
