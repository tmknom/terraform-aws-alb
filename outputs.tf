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
