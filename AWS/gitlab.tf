locals {
  pref = var.prefix != null ? "_${var.prefix}" : ""
}

resource "gitlab_project_variable" "audience_url" {
  for_each = toset(var.gitlab_project_ids)
  key     = "sts_audience_url${local.pref}_${var.environment}"
  project = each.value
  value   = var.audience_url
}

resource "gitlab_project_variable" "role_arn" {
  for_each = toset(var.gitlab_project_ids)
  key     = "sts_role_arn${local.pref}_${var.environment}"
  project = each.value
  value   = aws_iam_role.default.arn
}

resource "gitlab_project_variable" "account_id" {
  for_each = toset(var.gitlab_project_ids)
  key     = "aws_account_id${local.pref}_${var.environment}"
  project = each.value
  value   = var.aws_account_id
}