# Provider configuration

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }

    aap = {
      source  = "hashicorp/aap"
      version = ">= 1.2.0"
    }
  }
}

provider "aap" {
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy = "Terraform"
    }
  }
}

