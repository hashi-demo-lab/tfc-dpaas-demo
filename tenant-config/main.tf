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


# typically this would be extracted from TFE resources and arn referenced as this  but consolidating for demo simplicity
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

# Create the project and teams in Terraform Cloud
module "consumer_project" {
  source = "github.com/hashi-demo-lab/terraform-tfe-project-team"
  for_each = local.bu_projects_access # TO FIX - this is the wrong object should be per project


  organization_name = var.tfc_organization_name
  project_name      = "${each.value.bu}_${each.value.project}"
  business_unit     = each.value.bu

  team_project_access = try(each.value.value.team_project_access, {})
  custom_team_project_access = try(each.value.value.custom_team_project_access, {})

  bu_control_admins_id = tfe_team.bu_admin[each.value.bu].id

}

module "project_oidc" {
  source = "github.com/hashi-demo-lab/tfc-dpaas-demo//terraform-aws-oidc-dynamic-creds"

  oidc_provider_arn            = aws_iam_openid_connect_provider.tfc_provider.arn
  oidc_provider_client_id_list = [var.tfc_aws_audience]
  tfc_organization_name        = var.tfc_organization_name
  cred_type                    = var.cred_type
  tfc_project_name             = var.tfc_project_name
  tfc_project_id               = var.tfc_project_id

}