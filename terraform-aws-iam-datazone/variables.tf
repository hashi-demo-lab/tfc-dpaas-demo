## Variables file

variable "aws_account" {
  type        = string
  description = "AWS Account ID"
  default     = "855831148133"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "ap-southeast-2"
}


variable "datazone_domain_id" {
  type        = string
  description = "DataZone Domain ID"
  default     = "d-1234567890"
}