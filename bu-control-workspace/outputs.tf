
output "varsetMap" {
  value = local.varsetMap
}

output "variable_set" {
  value = module.terraform-tfe-variable-sets
}

output "project_id" {
  value = module.workspace
}

output "bu_project" {
  value = var.bu_project
}