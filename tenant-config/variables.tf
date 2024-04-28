variable "cred_type" {
    type = string
    description = "(optional) describe your variable"
    default = "project"
}

variable "project_name" {
    type = string
    description = "(optional) describe your variable"
}

variable "tfc_organization_name" {
    type = string
    description = "hcp terraform cloud organization name"
    default = "tfc-demo-au"
}

variable "tfc_project_name" {
    type = string
    description = "tfc project name"
}

variable "tfc_project_id" {
    type = string
    description = "tf cloud project id"
    default = ""
}

variable "oidc_provider_arn" {
    type = string
    description = "oidc provider arn"
}

variable "oidc_provider_client_id_list" {
    type = list(string)
    description = "oidc provider client id list"
    default = ["aws.workload.identity"]
}