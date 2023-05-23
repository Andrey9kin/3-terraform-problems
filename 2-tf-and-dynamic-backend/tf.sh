#!/usr/bin/env bash

set -euxo pipefail

export TF_STATE_FILE_NAME=${TF_STATE_FILE_NAME:-main.tfstate}
export TF_TERRAFORM_EXECUTABLE=${TF_TERRAFORM_EXECUTABLE:-terraform}

export REPO_NAME=$(basename $(git rev-parse --show-toplevel))
export ENVIRONMENT_ID=$(aws sts get-caller-identity --query Account --output text)
export BUCKET="infra-state-${ENVIRONMENT_ID}"
export STATE_PATH="terraform/${REPO_NAME}/${TF_STATE_FILE_NAME}"
export TF_DATA_DIR=".terraform.${ENVIRONMENT_ID}"

echo "Using remote state s3://${BUCKET}/${STATE_PATH}"
terraform init \
  -backend-config "key=${STATE_PATH}" \
  -backend-config "bucket=${BUCKET}" \
  -backend-config "region=${AWS_DEFAULT_REGION}"

${TF_TERRAFORM_EXECUTABLE} "$*"
