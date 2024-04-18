# can't use github secrets because IAM role does not respect regex
resource "github_actions_variable" "github_variables" {
  for_each = tomap({
    for git_var in local.github_variables : "${git_var.name}_github_variable" => git_var
  })
  repository       = each.value.repo
  variable_name    = each.value.name
  value            = each.value.value
}