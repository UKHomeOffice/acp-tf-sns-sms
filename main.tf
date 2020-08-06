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