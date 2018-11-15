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
  default     = false
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
