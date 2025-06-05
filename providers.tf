# Provider configuration

terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  # Uncomment the following lines to use a specific profile or credentials
  # profile = "your-profile-name"
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
  
  default_tags {
    tags = {
      ManagedBy = "Terraform"
    }
  }
}

