## Place your outputs here for your module

/* output "output-example" {
  value       = vault_policy.policies
  description = "Sample helm values file that contains all of the configured paths that were created with this module. This should be used a reference and not a raw input to another object"
} */

output "master_password_secret_arn" {
  description = "ARN of managed master password secret"
  value       = module.redshift.master_password_secret_arn
}