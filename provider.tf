terraform {
  required_version = "~> 1.7"
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 16.8.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

provider "gitlab" {
  token = var.gitlab_token
}
