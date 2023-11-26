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

module "network" {
  source = "./module/network"

  app_name   = var.app_name
  az-1a         = var.az-1a
  az-1c         = var.az-1c
  vpc_cidr      = var.vpc_cidr
  public1_cidr  = var.public1_cidr
  public2_cidr  = var.public2_cidr
  all_cidr      = var.all
}

module "ecs" {
  source = "./module/ecs"

  vpc_id = module.network.vpc_id
  public_id = module.network.public1_id
  ecs_instance_profile = module.iam.ecs_instance_profile
  ecs_task_execution_role = module.iam.ecs_task_execution_role
  app_name = var.app_name
  key_name = var.key_neme
}

module "iam" {
  source = "./module/iam"
}

module "cloudWatch" {
  source = "./module/cloudwatch"
}