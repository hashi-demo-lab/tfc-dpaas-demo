## Place your outputs here for your module

/* output "output-example" {
  value       = vault_policy.policies
  description = "Sample helm values file that contains all of the configured paths that were created with this module. This should be used a reference and not a raw input to another object"
} */
output "s3_datazone" {
  value = aws_s3_bucket.datazone.id
}
output "s3_datazone_region" {
  value = aws_s3_bucket.datazone.region
}