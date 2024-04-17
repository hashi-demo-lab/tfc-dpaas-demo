## Variables file

variable "datazone_domain_name" {
  description = "The name of the aws datazone domain"
  type        = string
}

variable "datazone_description" {
  description = "The description of the aws datazone domain"
  type        = string
  default     = "AWS DataZone Domain"
}

variable "datazone_domain_execution_role_arn" {
  description = "datazone domain exectuion role arn"
  type        = string
  default = "arn:aws:iam::855831148133:role/service-role/AmazonDataZoneDomainExecution"
}

variable "datazone_kms_key_identifier" {
  description = "The KMS key identifier to use for encryption"
  type        = string
  default     = null
}

variable "tags" {
  description = "The tags to apply to the domain"
  type        = any
  default     = null
}

variable "region" {
  description = "The region to deploy the domain"
  type        = string
  default     = "ap-southeast-2"
}