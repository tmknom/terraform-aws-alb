# Terraform module which creates ALB resources on AWS.
#
# With ALB, cross-zone load balancing is always enabled.
# Therefore, not specified "enable_cross_zone_load_balancing".
# https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/how-elastic-load-balancing-works.html#cross-zone-load-balancing
#
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html

# https://www.terraform.io/docs/providers/aws/r/lb.html
resource "aws_lb" "default" {
  load_balancer_type = "application"

  # The name of your ALB must be unique within your set of ALBs and NLBs for the region,
  # can have a maximum of 32 characters, can contain only alphanumeric characters and hyphens,
  # must not begin or end with a hyphen, and must not begin with "internal-".
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancer-getting-started.html#configure-load-balancer
  name = "${var.name}"

  # If true, the ALB will be internal.
  internal = "${var.internal}"

  # A list of security group IDs to assign to the ALB.
  # The rules for the security groups associated with your load balancer security group
  # must allow traffic in both directions on both the listener and the health check ports.
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html#load-balancer-security-groups
  security_groups = ["${aws_security_group.default.id}"]

  # A list of subnet IDs to attach to theA LB.
  subnets = ["${var.subnets}"]

  # The time in seconds that the connection is allowed to be idle.
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html#connection-idle-timeout
  idle_timeout = "${var.idle_timeout}"

  # To prevent your load balancer from being deleted accidentally, you can enable deletion protection.
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html#deletion-protection
  enable_deletion_protection = "${var.enable_deletion_protection}"

  # You can send up to 128 requests in parallel using one HTTP/2 connection.
  # The load balancer converts these to individual HTTP/1.1 requests
  # and distributes them across the healthy targets in the target group.
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html#listener-configuration
  enable_http2 = "${var.enable_http2}"

  # The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack.
  # If dualstack, must specify subnets with an associated IPv6 CIDR block.
  # Note that internal load balancers must use ipv4.
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html#ip-address-type
  ip_address_type = "${var.ip_address_type}"

  # ALB provides access logs that capture detailed information about requests sent to your load balancer.
  # Even if access_logs_enabled set false, you need to specify the valid bucket to access_logs_bucket.
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html
  access_logs {
    bucket  = "${var.access_logs_bucket}"
    prefix  = "${var.access_logs_prefix}"
    enabled = "${var.access_logs_enabled}"
  }

  # A mapping of tags to assign to the resource.
  tags = "${var.tags}"
}

# When you create a listener, you define actions for the default rule. Default rules can't have conditions.
# If no conditions for any of a listener's rules are met, then the action for the default rule is performed.
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html#listener-rules
#
# https://www.terraform.io/docs/providers/aws/r/lb_listener.html
resource "aws_lb_listener" "https" {
  load_balancer_arn = "${aws_lb.default.arn}"
  port              = "${var.https_port}"
  protocol          = "HTTPS"

  # You can choose the security policy that is used for front-end connections.
  # We recommend the ELBSecurityPolicy-2016-08 policy for general use.
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html#describe-ssl-policies
  ssl_policy = "${var.ssl_policy}"

  # When you create an HTTPS listener, you must specify a default certificate.
  # You can create an optional certificate list for the listener by adding more certificates.
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html#https-listener-certificates
  #
  # If you wish adding more certificates, then use aws_lb_listener_certificate resource.
  # https://www.terraform.io/docs/providers/aws/r/lb_listener_certificate.html
  certificate_arn = "${var.certificate_arn}"

  default_action {
    # You can use this action to return a 2XX, 4XX, or 5XX response code and an optional message.
    # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html#fixed-response-actions
    type = "fixed-response"

    fixed_response {
      content_type = "${var.fixed_response_content_type}"
      message_body = "${var.fixed_response_message_body}"
      status_code  = "${var.fixed_response_status_code}"
    }
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.default.arn}"
  port              = "${var.http_port}"
  protocol          = "HTTP"

  default_action {
    # You can use this action to return a 2XX, 4XX, or 5XX response code and an optional message.
    # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html#fixed-response-actions
    type = "fixed-response"

    fixed_response {
      content_type = "${var.fixed_response_content_type}"
      message_body = "${var.fixed_response_message_body}"
      status_code  = "${var.fixed_response_status_code}"
    }
  }
}

# NOTE on Security Groups and Security Group Rules:
# At this time you cannot use a Security Group with in-line rules in conjunction with any Security Group Rule resources.
# Doing so will cause a conflict of rule settings and will overwrite rules.
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "default" {
  name   = "${var.name}-alb"
  vpc_id = "${var.vpc_id}"

  tags = "${merge(map("Name", var.name), var.tags)}"
}

# https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
resource "aws_security_group_rule" "ingress_https" {
  type              = "ingress"
  from_port         = "${var.https_port}"
  to_port           = "${var.https_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.ingress_cidr_blocks}"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  from_port         = "${var.http_port}"
  to_port           = "${var.http_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.ingress_cidr_blocks}"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.default.id}"
}
