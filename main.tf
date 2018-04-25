resource "aws_cloudwatch_event_rule" "rule" {
  name                = "taskhawk-${substr(var.name, 0, min(55, length(var.name)))}"
  description         = "${var.description}"
  schedule_expression = "${var.schedule_expression}"
}

data "template_file" "input" {
  template = "${file("${path.module}/input.${var.format_version}.tpl")}"

  vars = {
    headers = "${jsonencode(var.headers)}"
    task    = "${var.task}"
    args    = "${jsonencode(var.args)}"
    kwargs  = "${jsonencode(var.kwargs)}"
  }
}

resource "aws_cloudwatch_event_target" "target" {
  rule      = "${aws_cloudwatch_event_rule.rule.name}"
  target_id = "taskhawk-target-${substr(var.name, 0, min(48, length(var.name)))}"
  arn       = "${var.queue == "" ? var.topic : var.queue}"

  input_transformer = {
    input_paths = {
      "id"      = "$.id"
      "time"    = "$.time"
      "region"  = "$.region"
      "account" = "$.account"
    }

    # since go's default marshal (which is what Terraform uses), escapes <, > for HTML safety,
    # and AWS Cloudwatch template requires use of <id>, decode it back:
    input_template = "${replace(data.template_file.input.rendered, "\"\\u003cid\\u003e\"", "<id>")}"
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_rule" {
  count = "${var.queue == "" ? 1 : 0}"

  statement_id  = "AllowExecutionFromCloudwatchRule"
  action        = "lambda:InvokeFunction"
  function_name = "${var.function_name}"
  qualifier     = "${var.function_qualifier}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.rule.arn}"
}
