provider "aws" {
  region = var.region
}

terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "tfc-demo-au"

    workspaces {
      name    = "tfc-tenant-config"
      project = "platform_team"
    }
  }

}