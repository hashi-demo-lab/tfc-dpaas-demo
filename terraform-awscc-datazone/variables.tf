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
  default     = "arn:aws:iam::855831148133:role/service-role/AmazonDataZoneDomainExecution"
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

# Environment Blueprints - today only DefaultDataWarehouse, DefaultDataLake
variable "environment_blueprints" {
  description = "The environment blueprints to deploy"
  type = map(object({
    enabled_regions                  = list(string)
    environment_blueprint_identifier = string
    provisioning_role_arn            = optional(string)
    manage_access_role_arn           = optional(string)
    regional_parameters = optional(map(object({
      parameters = list(string)
      region     = string
    })))
  }))

  default = {
    DefaultDataWarehouse = {
      enabled_regions                  = ["ap-southeast-2"]
      environment_blueprint_identifier = "DefaultDataWarehouse"
    }
    DefaultDataLake = {
      enabled_regions                  = ["ap-southeast-2"]
      environment_blueprint_identifier = "DefaultDataLake"
    }
  }
}