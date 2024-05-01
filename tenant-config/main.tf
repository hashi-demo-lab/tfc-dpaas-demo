#read each yaml file in ./config/*.yaml
locals {
  config_file = flatten([for tenant in fileset(path.module, "config/*.yaml") : yamldecode(file(tenant))])
  tenant      = { for bu in local.config_file : bu.bu => bu }

  bu_project_list = flatten([
    for bu_key, bu_value in local.tenant : [
      for project_key, project_value in bu_value.projects : { "${bu_key}-${project_key}" : {
        bu      = bu_key
        project = project_key
        value   = project_value
        }
      }
    ]
  ])

  # convert list of bu_project_list to map
  bu_projects_access = { for bu_project in local.bu_project_list : keys(bu_project)[0] => values(bu_project)[0] }

}


# typically OIDC config would be extracted from TFE resources and an arn referenced as this requires higher privilege access 
# and usually cross-account workflow but consolidating for demo simplicity
# Data source used to grab the TLS certificate for Terraform Cloud.
data "tls_certificate" "tfc_certificate" {
  url = "https://${var.tfc_hostname}"
}

# Creates an OIDC provider which is restricted to
resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = data.tls_certificate.tfc_certificate.url
  client_id_list  = [var.tfc_aws_audience]
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
}
############################################


resource "tfe_team" "bu_admin" {
  for_each = local.tenant

  name         = "${each.value.bu}_admin"
  organization = var.tfc_organization_name
  sso_team_id  = try(each.value.value.team.sso_team_id, null)
}

resource "tfe_team_token" "bu_admin" {
  for_each = local.tenant
  team_id = tfe_team.bu_admin[each.key].id
}

resource "tfe_variable_set" "bu_admin" {
  for_each = local.tenant
  name         = "${each.value.bu}_admin"
  description  = "${each.value.bu} varset Managed by Terraform"
  organization = var.tfc_organization_name
}

resource "tfe_variable" "bu_admin" {
  for_each = local.tenant
  key             = "TFE_TOKEN"
  value           = tfe_team_token.bu_admin[each.key].token
  category        = "env"
  description     = "${each.value.bu} TFE Team Token"
  sensitive = true
  variable_set_id = tfe_variable_set.bu_admin[each.key].id
}

resource "tfe_project_variable_set" "bu_admin" {
  for_each = local.tenant
  variable_set_id = tfe_variable_set.bu_admin[each.key].id
  project_id      = tfe_project.bu_control[each.key].id
}

resource "tfe_project" "bu_control" {
  for_each = local.tenant
  name     = "${each.value.bu}_control"
  organization = var.tfc_organization_name
}

resource "tfe_team_project_access" "bu_control" {
  for_each = local.tenant
  access = "maintain"
  project_id = tfe_project.bu_control[each.key].id
  team_id = tfe_team.bu_admin[each.key].id
}

resource "tfe_workspace" "bu_control" {
  for_each = local.tenant
  name     = "${each.value.bu}_workspace_control"
  organization = var.tfc_organization_name
  auto_apply = false
  allow_destroy_plan = false
  project_id =  tfe_project.bu_control[each.key].id
}

# Create the project and teams in Terraform Cloud
module "consumer_project" {
  source = "github.com/hashi-demo-lab/terraform-tfe-project-team"
  for_each = local.bu_projects_access 


  organization_name = var.tfc_organization_name
  project_name      = "${each.value.bu}_${each.value.project}"
  business_unit     = each.value.bu

  team_project_access = try(each.value.value.team_project_access, {})
  custom_team_project_access = try(each.value.value.custom_team_project_access, {})

  bu_control_admins_id = tfe_team.bu_admin[each.value.bu].id
}


module "project_oidc" {
  source = "github.com/hashi-demo-lab/tfc-dpaas-demo//terraform-aws-oidc-dynamic-creds"
  for_each = module.consumer_project
  
  oidc_provider_arn            = aws_iam_openid_connect_provider.tfc_provider.arn
  oidc_provider_client_id_list = [var.tfc_aws_audience]
  tfc_organization_name        = var.tfc_organization_name
  cred_type                    = var.cred_type
  tfc_project_name             = module.consumer_project[each.key].project_name
  tfc_project_id               = module.consumer_project[each.key].project_id

}