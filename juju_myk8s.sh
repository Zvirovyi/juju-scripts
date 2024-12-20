#!/bin/bash

set -e

if [[ -n "$2" ]]; then
  export controller="$2"
else
  export controller="microk8s-localhost"
fi

if [[ "$1" == "off" ]]; then
	juju destroy-controller --destroy-all-models --force --destroy-storage --no-wait --no-prompt "$controller"
	sudo microk8s stop
elif [[ "$1" == "on" ]]; then
	sudo microk8s start
	juju bootstrap microk8s "$controller"
	juju model-defaults update-status-hook-interval=60s
	juju model-defaults logging-config="<root>=INFO;unit=DEBUG"
else
	echo "action: on / off"
fi
