
data "tfe_outputs" "domain" {
  workspace = var.workspace_name
}

module "datazone_environment" {
  source                        = "../../"
  region                        = var.region
  domain_id                     = try(var.domain_id, tfe_outputs.domain.outputs.domain_id)
  project_id                    = try(var.project_id, tfe_outputs.domain.outputs.project_id)
  environment_blueprint_id      = try(var.environment_blueprint_id, tfe_outputs.domain.outputs.environment_blueprint_id)
  datazone_environment_profiles = var.datazone_environment_profiles
  datazone_environments         = var.datazone_environments
}