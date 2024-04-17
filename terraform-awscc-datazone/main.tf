resource "awscc_datazone_domain" "name" {
  name = var.datazone_domain_name
  description = var.datazone_description
  domain_execution_role = var.datazone_domain_execution_role_arn
  tags = var.tags
  kms_key_identifier = var.datazone_kms_key_identifier
}