resource "gitlab_project_variable" "gitlab_variables" {
  for_each = tomap({
    for git_var in local.gitlab_variables : "${git_var.key}_gitlab_variable" => git_var
  })
  key     = each.value.key
  project = each.value.project
  value   = each.value.value
}