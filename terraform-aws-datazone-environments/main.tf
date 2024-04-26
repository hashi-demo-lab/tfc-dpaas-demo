# Due to separation of duties, the following resources below will be moved to a different module

# create environment profiles(s)
resource "awscc_datazone_environment_profile" "this" {
  for_each = var.datazone_environment_profiles

  aws_account_id                   = each.value.aws_account_id
  aws_account_region               = each.value.region
  domain_identifier                = var.domain_id
  environment_blueprint_identifier = var.environment_blueprint_id
  name                             = each.key
  description                      = try(each.value.description)
  project_identifier               = var.project_id
  user_parameters                  = try(each.value.user_parameters)
}

resource "awscc_datazone_environment" "this" {
  for_each = var.datazone_environments

  domain_identifier              = var.domain_id
  environment_profile_identifier = awscc_datazone_environment_profile.this[each.value.environment_profile_identifier].environment_profile_id
  name                           = each.value.name
  project_identifier             = var.project_id
}