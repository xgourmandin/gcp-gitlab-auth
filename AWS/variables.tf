variable "aws_account_id" {
  type        = string
  description = "The AWS account ID to connect to"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to connect to"
  default     = "eu-west-3"
}

variable "gitlab_url" {
  type        = string
  description = "Optional. A custom gitlab url for the configuration of on-premise instance"
  default     = "https://gitlab.com"

  validation {
    condition     = startswith(var.gitlab_url, "https://")
    error_message = "This module only works if the Gitlab instance is exposed with HTTPS."
  }
}
variable "gitlab_token" {
  type        = string
  description = "The gitlab token to authenticate with"
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

variable "gitlab_thumbprint"{
    type        = string
    description = "Gitlab thumbprint fore creating oidc. Can be found by simulating creation of an identity provider in AWS (with https://gitlab.com)."
}

variable "oidc_roles"{
    type = list(object({
      name               = string # name of the OIDC role. If default, then basic naming process (without prefix)
      gitlab_project_ids = list(string) # The gitlab project IDs to connect to the current OIDC role to AWS
      aws_policies       = optional(list(string)) # List of existing AWS predefined policies to attach the current OIDC role (e.g. , PowerUserAccess, IAMFullAccess)
      custom_policies    = optional(list(string)) # List of custom policies to attach to the current OIDC role (e.g., iam:*, sdb:*, ec2:*)
    }))
    description = "Define policies and prefixes to enable multiples roles for gitlab CI depending of needs. Use \"default\" as name to get basic naming ressources"
    default = []
}