terraform {
  required_version = "~> 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.98.0"
    }
  }

  # Opcional: Caso crie o bucket referenciado na branch 'Bucket' então descomente as linhas abaixo:
   backend "s3"{
     bucket = "devops-challence-20240202-prxm-remote-state"
     key = "instance/terraform.tfstate"
     region = "us-east-1"
   }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "owner"       = "Paulo Xavier"
      "Provisioner" = "Terraform"
      "Project"     = "Coodesh"
    }
  }
}