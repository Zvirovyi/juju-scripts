#!/bin/bash

if [[ -z "$1" ]]; then
  echo "destination machine is not specified" >&2
  exit 1
fi

if [[ -z "$2" ]]; then
  echo "destination path is not specified" >&2
  exit 1
fi

# Change GCP endpoint to AWS endpoint
SED_PATTERN="s|\"endpoint\": \"https://storage.googleapis.com\",|\"endpoint\": \"https://s3.amazonaws.com\",|g"
# Change empty GCP region to AWS region
SED_PATTERN="$SED_PATTERN; s|\"region\": \"\",|\"region\": \"us-east-1\",|g"
# Change GCP access-key to AWS access-key
SED_PATTERN="$SED_PATTERN; s|\"access-key\": github_secrets\[\"GCP_ACCESS_KEY\"\],|\"access-key\": github_secrets\[\"AWS_ACCESS_KEY\"\],|g"
# Change GCP secret-key to AWS secret-key
SED_PATTERN="$SED_PATTERN; s|\"secret-key\": github_secrets\[\"GCP_SECRET_KEY\"\],|\"secret-key\": github_secrets\[\"AWS_SECRET_KEY\"\],|g"

if [[ -n "$JUJU_SCRIPTS_REPOSSESS_DP_S3_BUCKET" ]]; then
    SED_PATTERN="$SED_PATTERN; s|\"bucket\": \"data-charms-testing\",|\"bucket\": \"$JUJU_SCRIPTS_REPOSSESS_DP_S3_BUCKET\",|g"
fi

if [[ -n "$JUJU_SCRIPTS_REPOSSESS_DP_S3_REGION" ]]; then
    SED_PATTERN="$SED_PATTERN; s|\"region\": \"us-east-1\",|\"region\": \"$JUJU_SCRIPTS_REPOSSESS_DP_S3_REGION\",|g"
fi

command="find \"$2\" -type f -exec sed -i '$SED_PATTERN' {} +"

# shellcheck disable=SC2029
ssh "$1" "$command"