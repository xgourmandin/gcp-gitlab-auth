variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID to connect to"
}

variable "gcp_region" {
  type        = string
  description = "The GCP region to connect to"
  default     = "europe-west1"
}

variable "extra_enabled_services" {
  default = []
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
  description = "The gitlab project IDs to connect to GCP"
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
