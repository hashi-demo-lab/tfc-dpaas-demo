module "datazone_iam" {
  source = "github.com/hashi-demo-lab/tfc-dpaas-demo//terraform-aws-oidc-dynamic-creds"

    oidc_provider_arn            = var.oidc_provider_arn
    oidc_provider_client_id_list = var.oidc_provider_client_id_list
    tfc_organization_name        = var.tfc_organization_name
    tfc_workspace_name           = var.tfc_workspace_name
    tfc_workspace_id             = var.tfc_workspace_id
    cred_type                    = var.cred_type
    tfc_workspace_project_name   = var.tfc_workspace_project_name
    tfc_workspace_project_id     = var.tfc_workspace_project_id

}