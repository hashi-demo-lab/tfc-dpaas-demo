
locals {
  modules_config = yamldecode(file("${path.module}/config/modules.yaml"))
}

resource "tfe_registry_module" "test-registry-module" {
  for_each = local.modules_config.modules

  test_config {
    tests_enabled = try(each.value.tests_enabled, var.tests_enabled)
  }

  vcs_repo {
    display_identifier = "${var.github_org}/${each.value.module_name}"
    identifier         = "${var.github_org}/${each.value.module_name}"
    oauth_token_id     = var.oauth_token
    branch             = var.branch
  }
}