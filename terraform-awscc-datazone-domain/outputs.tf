## Place your outputs here for your module

/* output "output-example" {
  value       = vault_policy.policies
  description = "Sample helm values file that contains all of the configured paths that were created with this module. This should be used a reference and not a raw input to another object"
} */
output "datazone_role_id" {
  value = awscc_iam_role.this.role_id
}

output "datazone_role_arn" {
  value = awscc_iam_role.this.arn
}
output "datazone_domain_id" {
  value = awscc_datazone_domain.this.domain_id
}

output "environment_project_id" {
  value = awscc_datazone_project.this["environment"].project_id
}
output "s3_datazone" {
  value = aws_s3_bucket.datazone.id
}
output "s3_datazone_region" {
  value = aws_s3_bucket.datazone.region
}

output "datazone_portal" {
  value = awscc_datazone_domain.this.portal_url
}

output "datazone_status" {
  value = awscc_datazone_domain.this.status
}