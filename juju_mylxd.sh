#!/bin/bash

set -e

if [[ -n "$2" ]]; then
  export controller="$2"
else
  export controller="localhost-localhost"
fi

if [[ "$1" == "off" ]]; then
	juju destroy-controller --destroy-all-models --force --destroy-storage --no-wait --no-prompt "$controller"
elif [[ "$1" == "on" ]]; then
	juju bootstrap localhost "$controller"
	juju model-defaults update-status-hook-interval=60s
	juju model-defaults logging-config="<root>=INFO;unit=DEBUG"
else
	echo "use argument: on / off"
fi
