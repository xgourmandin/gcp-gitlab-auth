resource "google_service_account" "default" {
  account_id = "${local.ressource_prefix}-sa"
}

locals {
  authorized_projects = [for p in var.gitlab_project_ids : "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.default.name}/attribute.project_id/${p}"]
}

resource "google_service_account_iam_binding" "default" {
  members            = local.authorized_projects
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.default.name
}

resource "google_project_iam_binding" "default" {
  members = [
    "serviceAccount:${google_service_account.default.email}",
  ]
  role    = "roles/editor"
  project = var.gcp_project_id
}