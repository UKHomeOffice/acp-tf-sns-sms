variable "display_name" {
  description = "Display name for sms messages"
}

variable "name" {
  description = "A descriptive name for the sms channel"
}

variable "source_account" {
  description = "The source account for messages to the sns topic"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "target_numbers" {
  description = "The sms numbers to send messages to"
  default = []
}