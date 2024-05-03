
data "tfe_outputs" "domain" {
  organization = var.organization
  workspace    = var.workspace_name
}

module "datazone_environment" {
  source = "../"

  region                        = var.region
  domain_id                     = try(var.domain_id, data.tfe_outputs.domain.values.domain_id)
  project_id                    = try(var.project_id, data.tfe_outputs.domain.values.project_id)
  environment_blueprint_id      = try(var.environment_blueprint_id, data.tfe_outputs.domain.values.environment_blueprint_id)
  datazone_environment_profiles = var.datazone_environment_profiles
  datazone_environments         = var.datazone_environments
}