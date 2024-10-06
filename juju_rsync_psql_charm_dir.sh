#!/bin/bash

set -e

DIRNAME=`basename $1`

juju_rsync_charm_dir.sh $1 "$2:$3"

juju_ssh_repossess_dp_s3.sh $2 "$3/$DIRNAME/tests/integration"