
locals {
  modules_config = yamldecode(file("${path.module}/config/modules.yaml"))
}

# publish modules to HCP Terraform registry
resource "tfe_registry_module" "publish" {
  for_each = local.modules_config.modules

  test_config {
    tests_enabled = try(each.value.tests_enabled, var.tests_enabled)
  }

  vcs_repo {
    display_identifier = "${var.github_org}/${each.value.module_name}"
    identifier         = "${var.github_org}/${each.value.module_name}"
    oauth_token_id     = var.oauth_token
    branch             = var.branch
    tags               = false
  }
}

# add labels used for module publishing pipeline to identify semver
resource "github_issue_label" "module" {
  for_each = local.labels_map

  repository = each.value.repo
  name       = each.value.label
  color      = each.value.color

}


#set variable used by module publishing pipeline
resource "github_actions_variable" "module" {
  for_each = local.var_map

  repository = each.value.module
  value = each.value.value
  variable_name = each.value.variable
  
}
