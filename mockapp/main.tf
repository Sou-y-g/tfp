#module "ecs" {
#  source = "./module/ecs"
#
#  ecs_instance_profile    = module.iam.ecs_instance_profile
#  ecs_task_execution_role = module.iam.ecs_task_execution_role
#  vpc_id                  = module.network.vpc_id
#  public_id               = module.network.public_id
#  tag                     = var.tag
#  az                      = var.az
#  vpc_cidr                = var.vpc_cidr
#  all_cidr                = var.all_cidr
#}
#
#module "cloudwatch" {
#  source = "./module/cloudwatch"
#}

#module "iam" {
#  source = "./module/iam"
#
#  tag                     = var.tag
#}

#module "appsync" {
#  source = "./modules/appsync"
#  // 必要な変数を渡す
#}
#
#module "cognito" {
#  source = "./modules/cognito"
#  // 必要な変数を渡す
#}
#
#module "dynamodb" {
#  source = "./modules/dynamodb"
#  // 必要な変数を渡す
#}
#