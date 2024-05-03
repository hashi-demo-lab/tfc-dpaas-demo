
locals {
  modules_config = yamldecode(file("${path.module}/config/modules.yaml"))
}

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

#add labels used for module publishing pipeline
resource "github_issue_labels" "module" {
  for_each = local.modules_config.modules

  repository = each.value.module_name

  label {
    name  = "semver:patch"
    color = "7b42bc"
  }

  label {
    name  = "semver:minor"
    color = "7b42bc"
  }

  label {
    name  = "semver:major"
    color = "7b42bc"
  }

}

locals {
  #nested map loop to get key of pipeline_vars
  pipeline_vars = { for module in local.modules_config.modules : module.module_name => module.pipeline_vars }

  variables_list = flatten([
    for module_key, attributes in local.pipeline_vars : [
      for attr_key, value in attributes : { "${module_key}_${attr_key}" : {
        module    = module_key
        variable = attr_key
        value     = value
      } }
  ]])

  var_map = merge([for item in local.variables_list : item]...)
}

output "test" {
  value = local.var_map
}

resource "github_actions_variable" "module" {
  for_each = local.var_map

  repository = each.value.module
  value = each.value.value
  variable_name = each.value.variable
  
}
