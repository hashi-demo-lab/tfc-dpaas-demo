terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.45.0"
    }
  }

  cloud {
    organization = "tfc-demo-au"

    workspaces {
      name    = "bu1_project_addmembers"
      project = "bu1_data_platform1"
    }
  }
}