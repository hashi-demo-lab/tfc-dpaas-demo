variable "oauth_token" {
  type        = string
  description = "OAuth token for the VCS provider"
}

variable "tfc_organization_name" {
  type        = string
  description = "Name of the TFC organization"
}

variable "github_org" {
  type        = string
  description = "GitHub organization name"
}

variable "branch" {
  type        = string
  description = "Branch of the VCS repository"
  default     = "main"
}

variable "tests_enabled" {
  type        = bool
  description = "Enable tests for the module"
  default     = true
}