module "alb" {
  source = "../../"
  name   = "minimal"

  vpc_id  = "${module.vpc.vpc_id}"
  subnets = ["${module.vpc.public_subnet_ids}"]
}

module "vpc" {
  source     = "git::https://github.com/tmknom/terraform-aws-vpc.git?ref=tags/1.0.0"
  cidr_block = "10.255.0.0/16"
  name       = "minimal"

  public_subnet_cidr_blocks = ["10.255.0.0/24", "10.255.1.0/24"]
  public_availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
}
