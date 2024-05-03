terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.54.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 0.7"
    }
  }
}