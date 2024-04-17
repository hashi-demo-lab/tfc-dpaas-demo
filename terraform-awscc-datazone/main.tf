resource "awscc_datazone_domain" "this" {
  name                  = var.datazone_domain_name
  description           = var.datazone_description
  domain_execution_role = var.datazone_domain_execution_role_arn
  tags                  = var.tags
  kms_key_identifier    = var.datazone_kms_key_identifier
  single_sign_on        = var.single_sign_on
}

# Data Zone blueprints
resource "awscc_datazone_environment_blueprint_configuration" "this" {
  for_each = var.environment_blueprints

  domain_identifier                = awscc_datazone_domain.this.id
  enabled_regions                  = each.value.enabled_regions
  environment_blueprint_identifier = each.value.environment_blueprint_identifier
  manage_access_role_arn           = try(each.value.manage_access_role_arn)
  provisioning_role_arn            = try(each.value.provisioning_role_arn)
}

#create a project(x)
resource "awscc_datazone_project" "this" {
  for_each = var.datazone_projects

  domain_identifier = awscc_datazone_domain.this.id
  name              = each.key
  description       = try(each.value.description)
  glossary_terms    = try(each.value.glossary_terms)
}

# create environment profiles(s)
resource "awscc_datazone_environment_profile" "this" {
  for_each = var.datazone_environment_profiles

  aws_account_id                   = each.value.aws_account_id
  aws_account_region               = each.value.region
  domain_identifier                = awscc_datazone_domain.this.id
  environment_blueprint_identifier = awscc_datazone_environment_blueprint_configuration.this[each.value.environment_blueprint_identifier].environment_blueprint_id
  name                             = each.key
  description                      = try(each.value.description)
  project_identifier               = awscc_datazone_project.this[each.value.project_name].project_id
}


resource "awscc_datazone_environment" "this" {
  for_each = var.datazone_environments

  domain_identifier              = awscc_datazone_domain.this.id
  environment_profile_identifier = awscc_datazone_environment_profile.this[each.value.environment_profile_identifier].environment_profile_id
  name                           = each.value.name
  project_identifier             = awscc_datazone_project.this[each.value.project_target].project_id
}