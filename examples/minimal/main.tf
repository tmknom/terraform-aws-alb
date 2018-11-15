module "alb" {
  source = "../../"
  name   = "minimal"

  access_logs_bucket = "${module.s3_lb_log.s3_bucket_id}"
  vpc_id             = "${module.vpc.vpc_id}"
  subnets            = ["${module.vpc.public_subnet_ids}"]
}

module "vpc" {
  source                    = "git::https://github.com/tmknom/terraform-aws-vpc.git?ref=tags/1.0.0"
  cidr_block                = "10.255.0.0/16"
  name                      = "minimal"
  public_subnet_cidr_blocks = ["10.255.0.0/24", "10.255.1.0/24"]
  public_availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
}

module "s3_lb_log" {
  source                = "git::https://github.com/tmknom/terraform-aws-s3-lb-log.git?ref=tags/1.0.0"
  name                  = "s3-lb-log-${data.aws_caller_identity.current.account_id}"
  logging_target_bucket = "${module.s3_access_log.s3_bucket_id}"
  force_destroy         = true
}

module "s3_access_log" {
  source        = "git::https://github.com/tmknom/terraform-aws-s3-access-log.git?ref=tags/1.0.0"
  name          = "s3-access-log-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

data "aws_caller_identity" "current" {}
