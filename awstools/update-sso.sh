#!/bin/bash

PROFILE="data-ingest-profile"
AWS_PATH=$(which aws)

# run aws commands
aws sso login --profile $PROFILE

# update aws credentials
aws configure export-credentials --profile $PROFILE --format env-no-export | \
  awk -F= '/AWS_ACCESS_KEY_ID/{print "aws_access_key_id="$2} /AWS_SECRET_ACCESS_KEY/{print "aws_secret_access_key="$2} /AWS_SESSION_TOKEN/{print "aws_session_token="$2}' | \
  while IFS= read -r line; do
    key=$(echo "$line" | cut -d= -f1)
    value=$(echo "$line" | cut -d= -f2)
    aws configure set "$key" "$value" --profile default
  done