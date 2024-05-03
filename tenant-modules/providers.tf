## Place your Terraform Args / Provider version args here
terraform {
  required_providers {


    tfe = {
      source  = "hashicorp/tfe"
      version = "0.54.0"
    }
  }

  /*   cloud {
    organization = "tfc-demo-au"

    workspaces {
      name = "bu1_workspace_control"
      project = "bu1_control"
    }
  } */

}


provider "tfe" {
  organization = var.tfc_organization_name
}
