terraform {
  required_version = "~> 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.98.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "owner"       = "Paulo Xavier"
      "Provisioner" = "Terraform"
      "project"     = "devops-challence-20240202"
    }
  }
}