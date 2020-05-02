module "alb" {
  source             = "../../"
  name               = "example"
  vpc_id             = module.vpc.vpc_id
  subnets            = [module.vpc.public_subnet_ids]
  access_logs_bucket = module.s3_lb_log.s3_bucket_id
  certificate_arn    = module.certificate.acm_certificate_arn

  # WARNING: If in production environment, you should delete this parameter or change to true.
  enable_deletion_protection = false
}

module "certificate" {
  source      = "git::https://github.com/tmknom/terraform-aws-acm-certificate.git?ref=tags/1.0.0"
  domain_name = "alb.${local.domain_name}"
  zone_id     = data.aws_route53_zone.default.id
}

module "vpc" {
  source                    = "git::https://github.com/tmknom/terraform-aws-vpc.git?ref=tags/1.0.0"
  cidr_block                = local.cidr_block
  name                      = "alb"
  public_subnet_cidr_blocks = [cidrsubnet(local.cidr_block, 8, 0), cidrsubnet(local.cidr_block, 8, 1)]
  public_availability_zones = [data.aws_availability_zones.available.names]
}

module "s3_lb_log" {
  source                = "git::https://github.com/tmknom/terraform-aws-s3-lb-log.git?ref=tags/1.0.0"
  name                  = "s3-lb-log-alb-${data.aws_caller_identity.current.account_id}"
  logging_target_bucket = module.s3_access_log.s3_bucket_id
  force_destroy         = true
}

module "s3_access_log" {
  source        = "git::https://github.com/tmknom/terraform-aws-s3-access-log.git?ref=tags/1.0.0"
  name          = "s3-access-log-alb-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

data "aws_route53_zone" "default" {
  name = "${local.domain_name}."
}

locals {
  cidr_block          = "10.255.0.0/16"
  domain_name         = var.domain_name != "" ? var.domain_name : local.default_domain_name
  default_domain_name = "example.com"
}

variable "domain_name" {
  default     = ""
  type        = string
  description = "If TF_VAR_domain_name set in the environment variables, then use that value."
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}
