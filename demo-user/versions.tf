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
      name    = "retail_project_addmembers"
      project = "retail_data_plaform"
    }
  }
}