resource "gitlab_project_variable" "workload_identity_provider" {
  for_each = toset(var.gitlab_project_ids)
  key     = "workload_id_provider_id_${var.environment}"
  project = each.value
  value   = google_iam_workload_identity_pool_provider.default.name
}

resource "gitlab_project_variable" "sa_email" {
  for_each = toset(var.gitlab_project_ids)
  key     = "service_account_email_${var.environment}"
  project = each.value
  value   = google_service_account.default.email
}

resource "gitlab_project_variable" "project_id" {
  for_each = toset(var.gitlab_project_ids)
  key     = "gcp_project_id_${var.environment}"
  project = each.value
  value   = var.gcp_project_id
}
