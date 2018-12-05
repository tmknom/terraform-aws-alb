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
  count = "${var.enable_https_listener ? 1 : 0}"

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
  count = "${var.enable_http_listener && !(var.enable_https_listener && var.enable_redirect_http_to_https_listener) ? 1 : 0}"

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

resource "aws_lb_listener" "redirect_http_to_https" {
  count = "${var.enable_http_listener && (var.enable_https_listener && var.enable_redirect_http_to_https_listener) ? 1 : 0}"

  load_balancer_arn = "${aws_lb.default.arn}"
  port              = "${var.http_port}"
  protocol          = "HTTP"

  default_action {
    # You can use redirect actions to redirect client requests from one URL to another.
    # You can configure redirects as either temporary (HTTP 302) or permanent (HTTP 301) based on your needs.
    # https://www.terraform.io/docs/providers/aws/r/lb_listener.html#redirect-action
    type = "redirect"

    redirect {
      port        = "${var.https_port}"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "default" {
  name   = "${var.name}"
  vpc_id = "${var.vpc_id}"

  # The port on which the targets receive traffic.
  # This port is used unless you specify a port override when registering the target.
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateTargetGroup.html
  port = "${var.target_group_port}"

  # The protocol to use for routing traffic to the targets.
  # For Application Load Balancers, the supported protocols are HTTP and HTTPS.
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateTargetGroup.html
  protocol = "${var.target_group_protocol}"

  # The type of target that you must specify when registering targets with this target group.
  # The possible values are instance (targets are specified by instance ID) or ip (targets are specified by IP address).
  # You can't specify targets for a target group using both instance IDs and IP addresses.
  #
  # If the target type is ip, specify IP addresses from the subnets of the virtual private cloud (VPC) for the target group,
  # the RFC 1918 range (10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16), and the RFC 6598 range (100.64.0.0/10).
  # You can't specify publicly routable IP addresses.
  #
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html#target-type
  target_type = "${var.target_type}"

  # The amount of time for Elastic Load Balancing to wait before deregistering a target.
  # The range is 0–3600 seconds.
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html#target-group-attributes
  deregistration_delay = "${var.deregistration_delay}"

  # The time period, in seconds, during which the load balancer sends
  # a newly registered target a linearly increasing share of the traffic to the target group.
  # The range is 30–900 seconds (15 minutes).
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html#target-group-attributes
  slow_start = "${var.slow_start}"

  # Your Application Load Balancer periodically sends requests to its registered targets to test their status.
  # These tests are called health checks.
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-health-checks.html
  health_check {
    # The ping path that is the destination on the targets for health checks.
    # Specify a valid URI (protocol://hostname/path?query).
    path = "${var.health_check_path}"

    # The number of consecutive successful health checks required before considering an unhealthy target healthy.
    # The range is 2–10.
    healthy_threshold = "${var.health_check_healthy_threshold}"

    # The number of consecutive failed health checks required before considering a target unhealthy.
    # The range is 2–10.
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"

    # The amount of time, in seconds, during which no response from a target means a failed health check.
    # The range is 2–60 seconds.
    timeout = "${var.health_check_timeout}"

    # The approximate amount of time, in seconds, between health checks of an individual target.
    # The range is 5–300 seconds.
    interval = "${var.health_check_interval}"

    # The HTTP codes to use when checking for a successful response from a target.
    # You can specify multiple values (for example, "200,202") or a range of values (for example, "200-299").
    matcher = "${var.health_check_matcher}"

    # The port the load balancer uses when performing health checks on targets.
    # The default is to use the port on which each target receives traffic from the load balancer.
    # Valid values are either ports 1-65536, or traffic-port.
    port = "${var.health_check_port}"

    # The protocol the load balancer uses when performing health checks on targets.
    # The possible protocols are HTTP and HTTPS.
    protocol = "${var.health_check_protocol}"
  }

  # A mapping of tags to assign to the resource.
  tags = "${var.tags}"
}

# Each rule has a priority. Rules are evaluated in priority order, from the lowest value to the highest value.
# The default rule is evaluated last. You can change the priority of a nondefault rule at any time.
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html#listener-rule-priority
#
# The priority for the rule between 1 and 50000.
# Leaving it unset will automatically set the rule with next available priority after currently existing highest rule.
# A listener can't have multiple rules with the same priority.
# https://www.terraform.io/docs/providers/aws/r/lb_listener_rule.html
resource "aws_lb_listener_rule" "https" {
  count = "${var.enable_https_listener ? 1 : 0}"

  listener_arn = "${aws_lb_listener.https.arn}"
  priority     = "${var.listener_rule_priority}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.default.arn}"
  }

  condition {
    field  = "${var.listener_rule_condition_field}"
    values = ["${var.listener_rule_condition_values}"]
  }

  # Changing the priority causes forces new resource, then network outage may occur.
  # So, specify resources are created before destroyed.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "http" {
  count = "${var.enable_http_listener && !(var.enable_https_listener && var.enable_redirect_http_to_https_listener) ? 1 : 0}"

  listener_arn = "${aws_lb_listener.http.arn}"
  priority     = "${var.listener_rule_priority}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.default.arn}"
  }

  condition {
    field  = "${var.listener_rule_condition_field}"
    values = ["${var.listener_rule_condition_values}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# NOTE on Security Groups and Security Group Rules:
# At this time you cannot use a Security Group with in-line rules in conjunction with any Security Group Rule resources.
# Doing so will cause a conflict of rule settings and will overwrite rules.
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "default" {
  name   = "${local.security_group_name}"
  vpc_id = "${var.vpc_id}"

  tags = "${merge(map("Name", local.security_group_name), var.tags)}"
}

locals {
  security_group_name = "${var.name}-alb"
}

# https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
resource "aws_security_group_rule" "ingress_https" {
  count = "${var.enable_https_listener ? 1 : 0}"

  type              = "ingress"
  from_port         = "${var.https_port}"
  to_port           = "${var.https_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.ingress_cidr_blocks}"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "ingress_http" {
  count = "${var.enable_http_listener ? 1 : 0}"

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
