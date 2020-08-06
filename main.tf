provider "aws" {
  region  = "eu-west-1"
}

resource "aws_sns_topic" "sns_topic" {
  name = "${var.name}-sms-sns-topic"
}