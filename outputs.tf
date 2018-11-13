output "alb_id" {
  value       = "${aws_lb.default.id}"
  description = "The ARN of the load balancer (matches arn)."
}

output "alb_arn" {
  value       = "${aws_lb.default.arn}"
  description = "The ARN of the load balancer (matches id)."
}

output "alb_arn_suffix" {
  value       = "${aws_lb.default.arn_suffix}"
  description = "The ARN suffix for use with CloudWatch Metrics."
}

output "alb_dns_name" {
  value       = "${aws_lb.default.dns_name}"
  description = "The DNS name of the load balancer."
}

output "alb_zone_id" {
  value       = "${aws_lb.default.zone_id}"
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
}

output "security_group_id" {
  value       = "${aws_security_group.default.id}"
  description = "The ID of the security group."
}

output "security_group_arn" {
  value       = "${aws_security_group.default.arn}"
  description = "The ARN of the security group."
}

output "security_group_vpc_id" {
  value       = "${aws_security_group.default.vpc_id}"
  description = "The VPC ID."
}

output "security_group_owner_id" {
  value       = "${aws_security_group.default.owner_id}"
  description = "The owner ID."
}

output "security_group_name" {
  value       = "${aws_security_group.default.name}"
  description = "The name of the security group."
}

output "security_group_description" {
  value       = "${aws_security_group.default.description}"
  description = "The description of the security group."
}

output "security_group_ingress" {
  value       = "${aws_security_group.default.ingress}"
  description = "The ingress rules."
}

output "security_group_egress" {
  value       = "${aws_security_group.default.egress}"
  description = "The egress rules."
}
