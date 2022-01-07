terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.32"
    }
  }
  required_version = ">= 0.14"
}

resource "aws_sns_topic" "sns_topic" {
  name = "${var.name}-sms-sns-topic"
  display_name = var.display_name

  tags = var.tags
}

resource "aws_sns_topic_policy" "sns_from_source_account" {
  arn    = aws_sns_topic.sns_topic.arn
  policy = data.aws_iam_policy_document.publish_from_source_account_policy.json
}

data "aws_iam_policy_document" "publish_from_source_account_policy" {
  policy_id = "${var.name}-sns-sms-policy"

  statement {
    actions = [
      "SNS:Publish",
    ]

    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        var.source_account,
      ]
    }

    resources = [
      aws_sns_topic.sns_topic.arn,
    ]

    sid = "publish_from_source_account"
  }
}

resource "aws_sns_topic_subscription" "sns_sms_subscription" {
  count     = length(var.target_numbers)
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "sms"
  endpoint  = var.target_numbers[count.index]
}
