output "cloudwatch_rule_arn" {
  value       = "${aws_cloudwatch_event_rule.rule.arn}"
  description = "ARN of the Cloudwatch rule"
}
