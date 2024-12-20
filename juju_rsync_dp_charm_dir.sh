#!/bin/bash

set -e

if [[ -z "$1" ]]; then
  echo "source path is not specified" >&2
  exit 1
fi

if [[ -z "$2" ]]; then
  echo "destination machine is not specified" >&2
  exit 1
fi

if [[ -z "$3" ]]; then
  echo "destination path is not specified" >&2
  exit 1
fi

dirname=$(basename "$1")

juju_rsync_charm_dir.sh "$1" "$2:$3"

juju_ssh_repossess_dp_s3.sh "$2" "$3/$dirname/tests/integration"