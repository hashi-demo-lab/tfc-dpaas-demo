## Place your outputs here for your module

/* output "output-example" {
  value       = vault_policy.policies
  description = "Sample helm values file that contains all of the configured paths that were created with this module. This should be used a reference and not a raw input to another object"
} */


output "glue_acces_role_arn" {
  value       = aws_iam_role.glue.arn
  description = "The ARN of the IAM role for the DataZone Glue role"
}

output "redshift_access_role_arn" {
  value       = aws_iam_role.redshift.arn
  description = "The ARN of the IAM role for the DataZone Redshift role"
}