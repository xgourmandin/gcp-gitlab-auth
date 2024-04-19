terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    bitbucket = {
      source = "DrFaust92/bitbucket"
      version = "2.40.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
  default_tags {
   tags = {
     Environment = var.environment
     Project     = "oidc-sts-${var.environment}"
   }
 }
}

provider "bitbucket" {
  #oauth_token = var.bitbucket_token #need premium package to get workspace OAut token available
  username = var.bitbucket_username
  password = var.bitbucket_app_password
}
