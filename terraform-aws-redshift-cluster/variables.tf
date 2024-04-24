## Variables file

variable "region" {
  description = "The region to deploy the redis-cluster in"
  type        = string
  default     = "ap-southeast-2"
}

variable "secondary_region" {
  description = "The region to deploy the redis-cluster in"
  type        = string
  default     = "ap-southeast-1"
}

variable "datazone_domain_id" {
  description = "Domain ID of datazone; input value is rendered as output in the terraform-awscc-datazone-domain module"
  type = string
  # default = ""
}

variable "datazone_project_id" {
  description = "Project ID of one of the projects associated to a datazone; input value is rendered as output in the terraform-awscc-datazone-domain module"
  type = string
  # default = ""
}