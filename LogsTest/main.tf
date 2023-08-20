module "vpc" {
  source = "./modules/vpc"
  region = var.region
}

module "ec2" {
  source     = "./modules/ec2"
  #region     = var.region
  subnet_id  = module.vpc.subnet_id
  security_group_id = module.vpc.security_group_id
}

# module "cloudwatch" {
#   source = "./modules/cloudwatch"
#   alarm_actions = [aws_sns_topic.example.arn]
#   instance_id = module.ec2.instance_id
# }
