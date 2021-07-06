Taskhawk Scheduler Terraform module
===================================

[Taskhawk](https://github.com/cloudchacho/taskhawk) is a replacement for celery that works on AWS SQS/SNS, while
keeping things pretty simple and straight forward. 

This module provides a custom [Terraform](https://www.terraform.io/) module for deploying Taskhawk infrastructure for
Taskhawk periodic jobs.

## Usage

```hcl
module "taskhawk-dev-myapp" {
  source = "cloudchacho/taskhawk-queue/aws"
  queue  = "DEV-MYAPP"
  iam    = true

  tags = {
    app     = "myapp"
    env     = "dev"
  }
}

module "taskhawk-dev-myapp-cron-nightly" {
  source      = "cloudchacho/taskhawk-scheduler/aws"
  queue       = "${module.taskhawk-dev-myapp.default_queue_arn}"
  name        = "dev-myapp-nightly-job"
  description = "nightly job"

  format_version = "v1.0"
  
  headers = {
    request_id = "<id>"
  }
  task    = "tasks.send_email"
  args    = [
    "hello@automatic.com",
    "Hello!"
  ]
  kwargs  = {
    from_email = "spam@example.com"
  }

  schedule_expression = "cron(0 10 * * ? *)"  
}
```

See [cron expressions](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html#CronExpressions) 
for more details on `schedule_expression`. The timezone is always UTC.

For Lambda apps, use `topic` instead of `queue`.

`version` indicates the message format version for the Taskhawk library.

The following templated variables may be used in `headers`, `args`, and `kwargs`:
`<id>`, `<time>`, `<region>`, `<account>`. More details in [Event Transformer docs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/CloudWatch-Events-Input-Transformer-Tutorial.html).

## Release Notes

[Github Releases](https://github.com/cloudchacho/terraform-aws-taskhawk-scheduler/releases)

## How to publish

Go to [Terraform Registry](https://registry.terraform.io/modules/cloudchacho/taskhawk-scheduler/aws), and Resync module.
