variable "aws_account_id" {
  type        = string
  description = "The AWS account ID to connect to"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to connect to"
  default     = "eu-west-3"
}

variable "repository_provider_url" {
  type        = string
  description = "A Github url for the configuration of AWS OIDC."

  validation {
    condition     = startswith(var.repository_provider_url, "https://")
    error_message = "This module only works if the url is exposed with HTTPS."
  }
}

variable "github_token" {
  type        = string
  description = "The Github token to authenticate with"
}

variable "environment" {
  type        = string
  description = "The environment to deploy"

  validation {
    condition = contains(["dev", "prod"], var.environment)
    error_message = "Valid values for var: environment are (dev, prod)."
  }
}

variable "audience_url"{
    type        = string
    description = "Audience url to enable call oidc identity provider in AWS."
}

variable "repository_filter_url"{
    type        = string
    description = "Repository url to limit repository to assume IAM role."
}

variable "repository_thumbprint"{
    type        = string
    description = "Repository thumbprint for creating oidc. Can be found by simulating creation of an identity provider in AWS (e.g https://token.actions.githubusercontent.com)."
}

variable "oidc_roles"{
    type = list(object({
      name               = string # name of the OIDC role. If default, then basic naming process (without prefix)
      repo_project_ids   = list(string) # The repository project IDs to connect to the current OIDC role to AWS
      aws_policies       = optional(list(string)) # List of existing AWS predefined policies to attach the current OIDC role (e.g. , PowerUserAccess, IAMFullAccess)
      custom_policies    = optional(list(string)) # List of custom policies to attach to the current OIDC role (e.g., iam:*, sdb:*, ec2:*)
    }))
    description = "Define policies and prefixes to enable multiples roles for CI depending of needs. Use \"default\" as name to get basic naming ressources"
    default = []
}