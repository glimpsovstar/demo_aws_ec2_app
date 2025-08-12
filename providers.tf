# Provider configuration

terraform {

  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }

    aap = {
      source  = "ansible/aap"
      version = "1.3.0-prerelease2"
    }
  }
}

provider "aap" {
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy = "HCP Terraform"
    }
  }
}

