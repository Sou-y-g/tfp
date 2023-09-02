terraform {
  required_version = "1.5.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.2"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "aws" {
  region = var.region_us
  alias  = "us"
}

module "route53" {
  source = "./module/route53"

  cf_dns_name = module.cloudfront.cf_dns_name
  cf_zone_id  = module.cloudfront.cf_zone_id
  tag         = var.tag
  domain_name = var.domain_name

  providers = {
    aws = aws.us
  }
}

module "cloudfront" {
  source = "./module/cloudfront"

  s3_domain_name = module.s3.s3_domain_name
  origin_id      = module.s3.origin_id
  acm_arn        = module.route53.acm_arn
  tag            = var.tag
  domain_name    = var.domain_name
}

module "s3" {
  source = "./module/s3"

  tag                 = var.tag
  cf_distribution_arn = module.cloudfront.cf_distribution_arn
}

module "apigateway" {
  source = "./module/apigateway"

  tag                 = var.tag
  hello_lambda_arn = module.lambda.hello_lambda_arn
}

module "lambda" {
  source = "./module/lambda"

  hello_lambda_role = module.iam.hello_lambda_role
  api_arn = module.apigateway.api_arn
  tag    = var.tag
  function_file_name = var.function_file_name
  module_path = var.module_path
}

module "iam" {
  source = "./module/iam"

  db_arn = module.dynamodb.db_arn
  tag    = var.tag
}

module "dynamodb" {
  source = "./module/dynamodb"

  tag    = var.tag
}