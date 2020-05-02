# terraform-aws-alb

[![Terraform Actions Status](https://github.com/tmknom/terraform-aws-alb/workflows/Terraform/badge.svg)](https://github.com/tmknom/terraform-aws-alb/actions?query=workflow%3ATerraform)
[![Markdown Actions Status](https://github.com/tmknom/terraform-aws-alb/workflows/Markdown/badge.svg)](https://github.com/tmknom/terraform-aws-alb/actions?query=workflow%3AMarkdown)
[![YAML Actions Status](https://github.com/tmknom/terraform-aws-alb/workflows/YAML/badge.svg)](https://github.com/tmknom/terraform-aws-alb/actions?query=workflow%3AYAML)
[![JSON Actions Status](https://github.com/tmknom/terraform-aws-alb/workflows/JSON/badge.svg)](https://github.com/tmknom/terraform-aws-alb/actions?query=workflow%3AJSON)
[![GitHub tag](https://img.shields.io/github/tag/tmknom/terraform-aws-alb.svg)](https://registry.terraform.io/modules/tmknom/alb/aws)
[![License](https://img.shields.io/github/license/tmknom/terraform-aws-alb.svg)](https://opensource.org/licenses/Apache-2.0)

Terraform module which creates ALB resources on AWS.

## Description

Provision [ALB](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html),
[ALB Listeners](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html),
[Target Groups](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html) and
[Security Groups](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-update-security-groups.html).

This module provides recommended settings:

- Enable HTTPS
- Enable HTTP/2
- Enable Access Logging
- Enable Deletion Protection
- Enable HTTP to HTTPS redirect
- Use AWS recommended SSL Policy

## Usage

### Minimal

```hcl
module "alb" {
  source             = "git::https://github.com/tmknom/terraform-aws-alb.git?ref=tags/2.0.0"
  name               = "minimal"
  vpc_id             = var.vpc_id
  subnets            = var.subnets
  access_logs_bucket = "s3-lb-log"
  certificate_arn    = var.certificate_arn
}
```

### Complete

```hcl
module "alb" {
  source             = "git::https://github.com/tmknom/terraform-aws-alb.git?ref=tags/2.0.0"
  name               = "complete"
  vpc_id             = var.vpc_id
  subnets            = var.subnets
  access_logs_bucket = "s3-lb-log"
  certificate_arn    = var.certificate_arn

  enable_https_listener                  = true
  enable_http_listener                   = true
  enable_redirect_http_to_https_listener = true

  internal                    = false
  idle_timeout                = 120
  enable_deletion_protection  = false
  enable_http2                = false
  ip_address_type             = "ipv4"
  access_logs_prefix          = "test"
  access_logs_enabled         = true
  ssl_policy                  = "ELBSecurityPolicy-2016-08"
  https_port                  = 443
  http_port                   = 8080
  fixed_response_content_type = "text/plain"
  fixed_response_message_body = "ok"
  fixed_response_status_code  = "200"
  ingress_cidr_blocks         = ["0.0.0.0/0"]

  target_group_port                = 8080
  target_group_protocol            = "HTTP"
  target_type                      = "ip"
  deregistration_delay             = 600
  slow_start                       = 0
  health_check_path                = "/"
  health_check_healthy_threshold   = 3
  health_check_unhealthy_threshold = 3
  health_check_timeout             = 3
  health_check_interval            = 60
  health_check_matcher             = 200
  health_check_port                = "traffic-port"
  health_check_protocol            = "HTTP"
  listener_rule_priority           = 1
  listener_rule_condition_field    = "path-pattern"
  listener_rule_condition_values   = ["/*"]
  enabled                          = true

  tags = {
    Name        = "complete"
    Environment = "prod"
  }
}
```

## Examples

- [Minimal](https://github.com/tmknom/terraform-aws-alb/tree/master/examples/minimal)
- [Complete](https://github.com/tmknom/terraform-aws-alb/tree/master/examples/complete)
- [Only HTTPS](https://github.com/tmknom/terraform-aws-alb/tree/master/examples/only_https)
- [Only HTTP](https://github.com/tmknom/terraform-aws-alb/tree/master/examples/only_http)

## Inputs

| Name                                   | Description                                                                                                                                 |  Type  |           Default           | Required |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | :----: | :-------------------------: | :------: |
| access_logs_bucket                     | The S3 bucket name to store the logs in. Even if access_logs_enabled set false, you need to specify the valid bucket to access_logs_bucket. | string |              -              |   yes    |
| name                                   | The name of the LB. This name must be unique within your AWS account.                                                                       | string |              -              |   yes    |
| subnets                                | A list of subnet IDs to attach to the LB. At least two subnets in two different Availability Zones must be specified.                       |  list  |              -              |   yes    |
| vpc_id                                 | VPC Id to associate with ALB.                                                                                                               | string |              -              |   yes    |
| access_logs_enabled                    | Boolean to enable / disable access_logs.                                                                                                    | string |           `true`            |    no    |
| access_logs_prefix                     | The S3 bucket prefix. Logs are stored in the root if not configured.                                                                        | string |           `` | no           |
| certificate_arn                        | The ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS.                                | string |           `` | no           |
| deregistration_delay                   | The amount time for the load balancer to wait before changing the state of a deregistering target from draining to unused.                  | string |            `300`            |    no    |
| enable_deletion_protection             | If true, deletion of the load balancer will be disabled via the AWS API.                                                                    | string |           `true`            |    no    |
| enable_http2                           | Indicates whether HTTP/2 is enabled in application load balancers.                                                                          | string |           `true`            |    no    |
| enable_http_listener                   | If true, the HTTP listener will be created.                                                                                                 | string |           `true`            |    no    |
| enable_https_listener                  | If true, the HTTPS listener will be created.                                                                                                | string |           `true`            |    no    |
| enable_redirect_http_to_https_listener | If true, the HTTP listener of HTTPS redirect will be created.                                                                               | string |           `true`            |    no    |
| enabled                                | Set to false to prevent the module from creating anything.                                                                                  | string |           `true`            |    no    |
| fixed_response_content_type            | The content type. Valid values are text/plain, text/css, text/html, application/javascript and application/json.                            | string |        `text/plain`         |    no    |
| fixed_response_message_body            | The message body.                                                                                                                           | string |       `404 Not Found`       |    no    |
| fixed_response_status_code             | The HTTP response code. Valid values are 2XX, 4XX, or 5XX.                                                                                  | string |            `404`            |    no    |
| health_check_healthy_threshold         | The number of consecutive health checks successes required before considering an unhealthy target healthy.                                  | string |             `5`             |    no    |
| health_check_interval                  | The approximate amount of time, in seconds, between health checks of an individual target.                                                  | string |            `30`             |    no    |
| health_check_matcher                   | The HTTP codes to use when checking for a successful response from a target.                                                                | string |            `200`            |    no    |
| health_check_path                      | The destination for the health check request.                                                                                               | string |             `/`             |    no    |
| health_check_port                      | The port to use to connect with the target.                                                                                                 | string |       `traffic-port`        |    no    |
| health_check_protocol                  | The protocol to use to connect with the target.                                                                                             | string |           `HTTP`            |    no    |
| health_check_timeout                   | The amount of time, in seconds, during which no response means a failed health check.                                                       | string |             `5`             |    no    |
| health_check_unhealthy_threshold       | The number of consecutive health check failures required before considering the target unhealthy.                                           | string |             `2`             |    no    |
| http_port                              | The HTTP port.                                                                                                                              | string |            `80`             |    no    |
| https_port                             | The HTTPS port.                                                                                                                             | string |            `443`            |    no    |
| idle_timeout                           | The time in seconds that the connection is allowed to be idle.                                                                              | string |            `60`             |    no    |
| ingress_cidr_blocks                    | List of Ingress CIDR blocks.                                                                                                                |  list  |      `[ "0.0.0.0/0" ]`      |    no    |
| internal                               | If true, the LB will be internal.                                                                                                           | string |           `false`           |    no    |
| ip_address_type                        | The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack.                            | string |           `ipv4`            |    no    |
| listener_rule_condition_field          | The name of the field. Must be one of path-pattern for path based routing or host-header for host based routing.                            | string |       `path-pattern`        |    no    |
| listener_rule_condition_values         | The path patterns to match. A maximum of 1 can be defined.                                                                                  |  list  |         `[ "/*" ]`          |    no    |
| listener_rule_priority                 | The priority for the rule between 1 and 50000.                                                                                              | string |           `50000`           |    no    |
| slow_start                             | The amount time for targets to warm up before the load balancer sends them a full share of requests.                                        | string |             `0`             |    no    |
| ssl_policy                             | The name of the SSL Policy for the listener. Required if protocol is HTTPS.                                                                 | string | `ELBSecurityPolicy-2016-08` |    no    |
| tags                                   | A mapping of tags to assign to all resources.                                                                                               |  map   |            `{}`             |    no    |
| target_group_port                      | The port on which targets receive traffic, unless overridden when registering a specific target.                                            | string |            `80`             |    no    |
| target_group_protocol                  | The protocol to use for routing traffic to the targets. Should be one of HTTP or HTTPS.                                                     | string |           `HTTP`            |    no    |
| target_type                            | The type of target that you must specify when registering targets with this target group. The possible values are instance or ip.           | string |            `ip`             |    no    |

## Outputs

| Name                                    | Description                                                                                |
| --------------------------------------- | ------------------------------------------------------------------------------------------ |
| alb_arn                                 | The ARN of the load balancer (matches id).                                                 |
| alb_arn_suffix                          | The ARN suffix for use with CloudWatch Metrics.                                            |
| alb_dns_name                            | The DNS name of the load balancer.                                                         |
| alb_id                                  | The ARN of the load balancer (matches arn).                                                |
| alb_target_group_arn                    | The ARN of the Target Group (matches id)                                                   |
| alb_target_group_arn_suffix             | The ARN suffix for use with CloudWatch Metrics.                                            |
| alb_target_group_id                     | The ARN of the Target Group (matches arn)                                                  |
| alb_target_group_name                   | The name of the Target Group.                                                              |
| alb_target_group_port                   | The port of the Target Group.                                                              |
| alb_zone_id                             | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |
| http_alb_listener_arn                   | The ARN of the HTTP listener (matches id)                                                  |
| http_alb_listener_id                    | The ARN of the HTTP listener (matches arn)                                                 |
| http_alb_listener_rule_arn              | The ARN of the HTTP rule (matches id)                                                      |
| http_alb_listener_rule_id               | The ARN of the HTTP rule (matches arn)                                                     |
| https_alb_listener_arn                  | The ARN of the HTTPS listener (matches id)                                                 |
| https_alb_listener_id                   | The ARN of the HTTPS listener (matches arn)                                                |
| https_alb_listener_rule_arn             | The ARN of the HTTPS rule (matches id)                                                     |
| https_alb_listener_rule_id              | The ARN of the HTTPS rule (matches arn)                                                    |
| redirect_http_to_https_alb_listener_arn | The ARN of the HTTP listener of HTTPS redirect (matches id)                                |
| redirect_http_to_https_alb_listener_id  | The ARN of the HTTP listener of HTTPS redirect (matches arn)                               |
| security_group_arn                      | The ARN of the alb security group.                                                         |
| security_group_description              | The description of the alb security group.                                                 |
| security_group_egress                   | The egress rules of the alb security group.                                                |
| security_group_id                       | The ID of the alb security group.                                                          |
| security_group_ingress                  | The ingress rules of the alb security group.                                               |
| security_group_name                     | The name of the alb security group.                                                        |
| security_group_owner_id                 | The owner ID of the alb security group.                                                    |
| security_group_vpc_id                   | The VPC ID of the alb security group.                                                      |

## Development

### Development Requirements

- [Docker](https://www.docker.com/)

### Configure environment variables

#### Terraform variables for examples

```shell
export TF_VAR_domain_name=example.org
```

#### AWS credentials

```shell
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=ap-northeast-1
```

### Installation

```shell
git clone git@github.com:tmknom/terraform-aws-alb.git
cd terraform-aws-alb
make install
```

### Makefile targets

```text
apply-complete                 Run terraform apply examples/complete
apply-minimal                  Run terraform apply examples/minimal
apply-only-http                Run terraform apply examples/only_http
apply-only-https               Run terraform apply examples/only_https
check-format                   Check format code
clean                          Clean .terraform
destroy-complete               Run terraform destroy examples/complete
destroy-minimal                Run terraform destroy examples/minimal
destroy-only-http              Run terraform destroy examples/only_http
destroy-only-https             Run terraform destroy examples/only_https
diff                           Word diff
docs                           Generate docs
format                         Format code
help                           Show help
install                        Install requirements
lint                           Lint code
plan-complete                  Run terraform plan examples/complete
plan-minimal                   Run terraform plan examples/minimal
plan-only-http                 Run terraform plan examples/only_http
plan-only-https                Run terraform plan examples/only_https
release                        Release GitHub and Terraform Module Registry
upgrade                        Upgrade makefile
```

### Releasing new versions

Bump VERSION file, and run `make release`.

### Terraform Module Registry

- <https://registry.terraform.io/modules/tmknom/alb/aws>

## License

Apache 2 Licensed. See LICENSE for full details.
