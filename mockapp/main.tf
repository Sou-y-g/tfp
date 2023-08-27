module "s3" {
  source = "./module/s3"

  tag = var.tag
  cf_distribution_arn = module.cloudfront.cf_distribution_arn
}

module "cloudfront" {
  source = "./module/cloudfront"

  domain_name = module.s3.domain_name
  origin_id   = module.s3.origin_id
  tag         = var.tag
}