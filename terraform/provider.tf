terraform {
  required_version = ">= 1.5.0" # Minimum terraform version required
  required_providers {
    aws = {
      source  = "hashicorp/aws" # where to find the provider 
      version = "~>5.0"         # any version of the provider that is compatible with 5.0
    }
  }
}

provider "aws" {
  region = var.region # AWS region to deploy resources
}
