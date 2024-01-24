resource "gitlab_project_variable" "workload_identity_provider" {
  key     = "workload_id_provider_id"
  project = var.gitlab_project_id
  value   = google_iam_workload_identity_pool_provider.default.id
}

resource "gitlab_project_variable" "sa_email" {
  key     = "service_account_email"
  project = var.gitlab_project_id
  value   = google_service_account.default.email
}
