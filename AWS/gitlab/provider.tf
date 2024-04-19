terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 16.8.0"
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

provider "gitlab" {
  token = var.gitlab_token
  base_url = var.repository_provider_url
}