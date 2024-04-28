module "project_oidc" {
  source = "github.com/hashi-demo-lab/tfc-dpaas-demo//terraform-aws-oidc-dynamic-creds"

    oidc_provider_arn            = var.oidc_provider_arn
    oidc_provider_client_id_list = var.oidc_provider_client_id_list
    tfc_organization_name        = var.tfc_organization_name
    cred_type                    = var.cred_type
    tfc_project_name   = var.tfc_project_name
    tfc_project_id     = var.tfc_project_id

}