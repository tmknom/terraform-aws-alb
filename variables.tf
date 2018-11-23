variable "name" {
  type        = "string"
  description = "The name of the LB. This name must be unique within your AWS account."
}

variable "subnets" {
  type        = "list"
  description = "A list of subnet IDs to attach to the LB. At least two subnets in two different Availability Zones must be specified."
}

variable "access_logs_bucket" {
  type        = "string"
  description = "The S3 bucket name to store the logs in. Even if access_logs_enabled set false, you need to specify the valid bucket to access_logs_bucket."
}

variable "vpc_id" {
  type        = "string"
  description = "VPC Id to associate with ALB."
}

variable "internal" {
  default     = false
  type        = "string"
  description = "If true, the LB will be internal."
}

variable "idle_timeout" {
  default     = 60
  type        = "string"
  description = "The time in seconds that the connection is allowed to be idle."
}

variable "enable_deletion_protection" {
  default     = true
  type        = "string"
  description = "If true, deletion of the load balancer will be disabled via the AWS API."
}

variable "enable_http2" {
  default     = true
  type        = "string"
  description = "Indicates whether HTTP/2 is enabled in application load balancers."
}

variable "ip_address_type" {
  default     = "ipv4"
  type        = "string"
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
}

variable "access_logs_prefix" {
  default     = ""
  type        = "string"
  description = "The S3 bucket prefix. Logs are stored in the root if not configured."
}

variable "access_logs_enabled" {
  default     = true
  type        = "string"
  description = "Boolean to enable / disable access_logs."
}

variable "enable_https_listener" {
  default     = true
  type        = "string"
  description = "If true, the HTTPS listener will be created."
}

variable "enable_http_listener" {
  default     = true
  type        = "string"
  description = "If true, the HTTP listener will be created."
}

variable "enable_redirect_http_to_https" {
  default     = false
  type        = "string"
  description = "If true, the HTTP listener of HTTPS redirection will be created."
}

variable "ssl_policy" {
  default     = "ELBSecurityPolicy-2016-08"
  type        = "string"
  description = "The name of the SSL Policy for the listener. Required if protocol is HTTPS."
}

variable "certificate_arn" {
  default     = ""
  type        = "string"
  description = "The ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS."
}

variable "https_port" {
  default     = 443
  type        = "string"
  description = "The HTTPS port."
}

variable "http_port" {
  default     = 80
  type        = "string"
  description = "The HTTP port."
}

variable "fixed_response_content_type" {
  default     = "text/plain"
  type        = "string"
  description = "The content type. Valid values are text/plain, text/css, text/html, application/javascript and application/json."
}

variable "fixed_response_message_body" {
  default     = "404 Not Found"
  type        = "string"
  description = "The message body."
}

variable "fixed_response_status_code" {
  default     = "404"
  type        = "string"
  description = "The HTTP response code. Valid values are 2XX, 4XX, or 5XX."
}

variable "target_group_port" {
  default     = "80"
  type        = "string"
  description = "The port on which targets receive traffic, unless overridden when registering a specific target."
}

variable "target_group_protocol" {
  default     = "HTTP"
  type        = "string"
  description = "The protocol to use for routing traffic to the targets. Should be one of HTTP or HTTPS."
}

variable "target_type" {
  default     = "ip"
  type        = "string"
  description = "The type of target that you must specify when registering targets with this target group. The possible values are instance or ip."
}

variable "deregistration_delay" {
  default     = "300"
  type        = "string"
  description = "The amount time for the load balancer to wait before changing the state of a deregistering target from draining to unused."
}

variable "slow_start" {
  default     = "0"
  type        = "string"
  description = "The amount time for targets to warm up before the load balancer sends them a full share of requests."
}

variable "health_check_path" {
  default     = "/"
  type        = "string"
  description = "The destination for the health check request."
}

variable "health_check_healthy_threshold" {
  default     = "5"
  type        = "string"
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy."
}

variable "health_check_unhealthy_threshold" {
  default     = "2"
  type        = "string"
  description = "The number of consecutive health check failures required before considering the target unhealthy."
}

variable "health_check_timeout" {
  default     = "5"
  type        = "string"
  description = "The amount of time, in seconds, during which no response means a failed health check."
}

variable "health_check_interval" {
  default     = "30"
  type        = "string"
  description = "The approximate amount of time, in seconds, between health checks of an individual target."
}

variable "health_check_matcher" {
  default     = "200"
  type        = "string"
  description = "The HTTP codes to use when checking for a successful response from a target."
}

variable "health_check_port" {
  default     = "traffic-port"
  type        = "string"
  description = "The port to use to connect with the target."
}

variable "health_check_protocol" {
  default     = "HTTP"
  type        = "string"
  description = "The protocol to use to connect with the target."
}

variable "ingress_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  type        = "list"
  description = "List of Ingress CIDR blocks."
}

variable "tags" {
  default     = {}
  type        = "map"
  description = "A mapping of tags to assign to all resources."
}
