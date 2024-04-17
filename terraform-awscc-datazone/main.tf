resource "awscc_datazone_domain" "this" {
  name = var.datazone_domain_name
  description = var.datazone_description
  domain_execution_role = var.datazone_domain_execution_role_arn
  tags = var.tags
  kms_key_identifier = var.datazone_kms_key_identifier
}


resource "awscc_datazone_environment_blueprint_configuration" "this" {
  for_each = var.environment_blueprints
  domain_identifier = awscc_datazone_domain.this.id
  enabled_regions = each.value.enabled_regions
  environment_blueprint_identifier = each.value.environment_blueprint_identifier
}