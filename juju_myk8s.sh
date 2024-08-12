#!/bin/bash

set -e

if [[ "$1" == "off" ]]; then
	juju destroy-controller --destroy-all-models --force --destroy-storage --no-wait --no-prompt microk8s-localhost
	sudo microk8s stop
elif [[ "$1" == "on" ]]; then
	sudo microk8s start
	juju bootstrap microk8s
	juju model-defaults update-status-hook-interval=60s
	juju model-defaults logging-config="<root>=INFO;unit=DEBUG"
else
	echo "use argument: on / off"
fi
