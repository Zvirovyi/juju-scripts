#!/bin/bash

set -e

if [[ "$1" == "off" ]]; then
	juju destroy-controller --destroy-all-models --force --destroy-storage --no-wait --no-prompt localhost-localhost
elif [[ "$1" == "on" ]]; then
	juju bootstrap localhost
	juju model-defaults update-status-hook-interval=60s
	juju model-defaults logging-config="<root>=INFO;unit=DEBUG"
else
	echo "use argument: on / off"
fi
