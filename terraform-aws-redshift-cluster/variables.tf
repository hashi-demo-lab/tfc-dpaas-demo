## Variables file

variable "region" {
  description = "The region to deploy the redis-cluster in"
  type        = string
  default     = "ap-southeast-2"
}

variable "secondary_region" {
  description = "The region to deploy the redis-cluster in"
  type        = string
  default     = "ap-south-1"
}
