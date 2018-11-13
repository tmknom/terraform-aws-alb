variable "name" {
  type        = "string"
  description = "The name of the LB. This name must be unique within your AWS account."
}

variable "subnets" {
  type        = "list"
  description = "A list of subnet IDs to attach to the LB. At least two subnets in two different Availability Zones must be specified."
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

variable "tags" {
  default     = {}
  type        = "map"
  description = "A mapping of tags to assign to all resources."
}
