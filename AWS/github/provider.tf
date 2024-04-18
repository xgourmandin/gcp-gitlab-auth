terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
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

provider "github" {
  token = var.github_token # or `GITHUB_TOKEN`
}
