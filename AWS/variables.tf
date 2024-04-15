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

variable "prefix" {
  type        = string
  description = "Optional. A prefix for the names of all resources created by this module"
  default     = null
}

variable "gitlab_project_ids" {
  type        = list(string)
  description = "The gitlab project IDs to connect to AWS"
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

variable "aws_account_policies" {
  type        = list(string)
  description = "List of existing AWS predefined policies to attach OIDC role. By Default AWS Editor role like"
  default = ["PowerUserAccess", "IAMFullAccess" ]
}

variable "sa_account_policies" {
  type        = list(string)
  description = "List of custom policies to attach to OIDC role (e.g., iam:*, sdb:*, ec2:*)."
  default     = null
}

variable "audience_url"{
    type        = string
    description = "Audience url to enable call oidc identity provider in AWS."
}

variable "gitlab_thumbprint"{
    type        = string
    description = "Gitlab thumbprint fore creating oidc. Can be found by simulating creation of an identity provider in AWS (with https://gitlab.com)."
}