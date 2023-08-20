#!/bin/bash

# アプリケーション名を引数から取得
echo "what's your app name? :"
read APP_NAME

#providers.tfの作成
cat <<EOF > provider.tf
terraform {
  required_version = "1.5.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.6.2"
    }
  }
}

provider "aws" {
  region = var.region
}

EOF

# variables.tfの作成
cat << EOF > variables.tf
variable "region" {
  description = "The region where to deploy the infrastructure"
  type        = string
  default     = "ap-northeast-1"
}

variable "tag" {
  description = "Prefix for the tags"
  default     = "${APP_NAME}"
}

EOF

cat << EOF > .gitignore
#Local .terraform directories
**/.terraform/*
.terraform.lock.hcl

#.tfstate files
*.tfstate
*.tfstate.*

# .tfvars files
*.tfvars

EOF

#root ディレクトリにファイルを作成
touch main.tf variables.tf outputs.tf

# ディレクトリを作成
mkdir -p module
mkdir -p module/network
mkdir -p module/ec2
mkdir -p module/cloudwatch
mkdir -p module/db