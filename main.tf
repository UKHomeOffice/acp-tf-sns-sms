terraform {
  required_version = ">= 0.12"
}

resource "aws_kms_key" "sns_kms_key" {
  description             = "KMS key for ${var.name} sns to sms channel"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "sns_kms_key_alias" {
  name          = "alias/${var.name}-sns-sms-kms"
  target_key_id = aws_kms_key.sns_kms_key.key_id
}

resource "aws_sns_topic" "sns_topic" {
  name = "${var.name}-sms-sns-topic"
  kms_master_key_id = aws_kms_alias.sns_kms_key_alias.name
}

data "aws_iam_policy_document" "sns_assume_role" {
  statement {
    actions    = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "sms_publish" {
  statement {
    actions   = ["sns:Publish"]
    resources = ["${aws_sns_topic.sns_topic.arn}"]
  }
}

resource "aws_iam_policy" "sms_publish" {
  name        = "${var.name}-publish-policy"
  description = "Allow publishing to Group SMS SNS Topic"
  policy      = "${data.aws_iam_policy_document.sms_publish.json}"
}

resource "aws_sns_topic_subscription" "sns_sms_subscription" {
  count     = length("${var.target_numbers}")
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "sms"
  endpoint  = element("${var.target_numbers}", count.index)
}