#!/usr/bin/env bash

set -euxo pipefail

export REPO_NAME=$(basename $(git rev-parse --show-toplevel))
export ENVIRONMENT_ID=$(aws sts get-caller-identity --query Account --output text)
export BUCKET="myproject-infra-${ENVIRONMENT_ID}"
export STATE_PATH="terraform/${REPO_NAME}/main.tfstate"

terraform init -backend-config "key=${STATE_PATH}" -backend-config "bucket=${BUCKET}" -backend-config "region=${AWS_DEFAULT_REGION}"

terraform "$*"