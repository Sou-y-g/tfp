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
  region = var.us_region
  alias  = "us"
}

module "network" {
  source = "./module/network"

  tag           = var.tag
  az-1a         = var.az-1a
  az-1c         = var.az-1c
  vpc_cidr      = var.vpc_cidr
  public1_cidr  = var.public1_cidr
  public2_cidr  = var.public2_cidr
  private1_cidr = var.private1_cidr
  private2_cidr = var.private2_cidr
  all_cidr      = var.all
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

module "alb" {
  source = "./module/alb"

  vpc_id     = module.network.vpc_id
  public1_id = module.network.public1_id
  public2_id = module.network.public2_id
  tag        = var.tag
  all_cidr   = var.all
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