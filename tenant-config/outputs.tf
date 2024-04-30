
output "bu" {
  value       = local.tenant
  description = "The name of the business unit projects."
}


output "bu_project_projects" {
  value = local.bu_projects_access
}


output "projects" {
  value = module.consumer_project
}