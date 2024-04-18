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
  description = "A Bitbucket url for the configuration of AWS OIDC. (can be found in Bitbucket --> Repository settings --> OpenID Connect)"

  validation {
    condition     = startswith(var.repository_provider_url, "https://")
    error_message = "This module only works if the url is exposed with HTTPS."
  }
}

variable "bitbucket_username" {
  type        = string
  description = "The Bitbucket usrname to authenticate with"
}

variable "bitbucket_app_password" {
  type        = string
  description = "The Bitbucket App password to authenticate with (with pipelines variable scope)"
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
    description = "Audience url to enable call oidc identity provider in AWS. (can be found in Bitbucket --> Repository settings --> OpenID Connect)"
}

variable "repository_filter_url"{
    type        = string
    description = "Bitbucket workspace name to assume IAM role."
}

variable "repository_thumbprint"{
    type        = string
    description = "Repository thumbprint for creating oidc. Can be found by simulating creation of an identity provider in AWS (can be found in Bitbucket --> Repository settings --> OpenID Connect)."
}

variable "oidc_roles"{
    type = list(object({
      name               = string # name of the OIDC role. If default, then basic naming process (without prefix)
      repo_project_ids   = list(string) # The repository project IDs to connect to the current OIDC role to AWS (need to be into the same workspace)
      aws_policies       = optional(list(string)) # List of existing AWS predefined policies to attach the current OIDC role (e.g. , PowerUserAccess, IAMFullAccess)
      custom_policies    = optional(list(string)) # List of custom policies to attach to the current OIDC role (e.g., iam:*, sdb:*, ec2:*)
    }))
    description = "Define policies and prefixes to enable multiples roles for CI depending of needs. Use \"default\" as name to get basic naming ressources"
    default = []
}