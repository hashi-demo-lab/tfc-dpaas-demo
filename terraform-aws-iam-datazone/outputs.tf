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

output "datazone_access_arns" {
  value       = {
    DefaultDataWarehouse = aws_iam_role.redshift.arn
    DefaultDataLake      = aws_iam_role.glue.arn
  }
}



output "lakeformation_s3_provisioning_role_arn" {
  value       = aws_iam_role.s3lakeformation.arn
  description = "The ARN of the IAM role for the DataZone LakeFormation S3 role"
}