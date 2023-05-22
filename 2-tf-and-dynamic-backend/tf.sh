#!/usr/bin/env bash

set -euxo pipefail

export TF_STATE_FILE_NAME=${TF_STATE_FILE_NAME:-main.tfstate}
export TF_TERRAFORM_EXECUTABLE=${TF_TERRAFORM_EXECUTABLE:-terraform}

export REPO_NAME=$(basename $(git rev-parse --show-toplevel))
export ENVIRONMENT_ID=$(aws sts get-caller-identity --query Account --output text)
export BUCKET="myproject-infra-${ENVIRONMENT_ID}"
export STATE_PATH="terraform/${REPO_NAME}/main.tfstate"

terraform init -backend-config "key=${STATE_PATH}" -backend-config "bucket=${BUCKET}" -backend-config "region=${AWS_DEFAULT_REGION}"

terraform "$*"