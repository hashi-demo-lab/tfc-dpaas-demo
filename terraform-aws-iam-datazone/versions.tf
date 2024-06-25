terraform {
  required_providers {
   awscc = {
      source  = "hashicorp/awscc"
      version = "~> 1.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.4"
    }
  }
}