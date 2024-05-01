## Place your Terraform Args / Provider version args here
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.2.1"
    }

    tfe = {
      source = "hashicorp/tfe"
      version = "0.54.0"
    }
  }
}

provider "github" {
  # Configuration options
  owner = var.github_org
}
