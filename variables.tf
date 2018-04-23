variable "queue" {
  description = "Application SQS queue ARN (either this or topic must be specified)"
  default     = ""
}

variable "topic" {
  description = "Application SNS topic ARN (either this or queue must be specified)"
  default     = ""
}

variable "name" {
  description = "Rule name (must be unique across all taskhawk schedules)"
}

variable "schedule_expression" {
  description = "Cloudwatch cron schedule expression"
}

variable "description" {
  description = "Description of the Cloudwatch event rule"
  default     = ""
}

variable "format_version" {
  description = "Taskhawk message format version"
  default     = "v1.0"
}

variable "headers" {
  description = "Custom headers"
  type        = "map"
  default     = {}
}

variable "task" {
  description = "Name of the task"
}

variable "args" {
  description = "Args"
  type        = "list"
  default     = []
}

variable "kwargs" {
  description = "Keyword args"
  type        = "map"
  default     = {}
}
