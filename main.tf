terraform {
  required_version = ">= 0.12"
}

resource "aws_kms_key" "kms_key" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "kms_key_alias" {
  name          = "alias/${name}-sns-sms-kms"
  target_key_id = aws_kms_key.kms_key.key_id
}

resource "aws_sns_topic" "sns_topic" {
  name = "${var.name}-sms-sns-topic"
  kms_master_key_id = aws_kms_alias.kms_key_alias.name
}