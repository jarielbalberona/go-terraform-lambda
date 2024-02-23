terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "silk-datalake-terraform-state"
    key            = "terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
  }
}


provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key 
  
default_tags {
  tags = {
      Environment = var.environment
      Project     = var.project
    }
  }
}

data "aws_region" "current" {}