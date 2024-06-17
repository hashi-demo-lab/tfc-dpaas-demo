provider "aws" {
  region = var.region
}

terraform {
  cloud {
    hostname     = "tfe.simon-lynch.sbx.hashidemos.io"
    organization = "tfc-demo-au"

    workspaces {
      name    = "tfc-tenant-config"
      project = "platform_team"
    }
  }

}