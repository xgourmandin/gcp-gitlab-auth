resource "gitlab_project_variable" "workload_identity_provider" {
  for_each = toset(var.gitlab_project_ids)
  key     = "workload_id_provider_id"
  project = each.value
  value   = google_iam_workload_identity_pool_provider.default.id
}

resource "gitlab_project_variable" "sa_email" {
  for_each = toset(var.gitlab_project_ids)
  key     = "service_account_email"
  project = each.value
  value   = google_service_account.default.email
}
