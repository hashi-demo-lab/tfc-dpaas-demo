## Place your outputs here for your module

/* output "output-example" {
  value       = vault_policy.policies
  description = "Sample helm values file that contains all of the configured paths that were created with this module. This should be used a reference and not a raw input to another object"
} */


output "cluster_arn" {
  description = "The Redshift cluster ARN"
  value       = module.redshift.cluster_arn
}

output "cluster_id" {
  description = "The Redshift cluster ID"
  value       = module.redshift.cluster_id
}

output "cluster_identifier" {
  description = "The Redshift cluster identifier"
  value       = module.redshift.cluster_identifier
}

output "cluster_database_name" {
  description = "The name of the default database in the Cluster"
  value       = module.redshift.cluster_database_name
}

output "master_password_secret_arn" {
  description = "ARN of managed master password secret"
  value       = module.redshift.master_password_secret_arn
}

