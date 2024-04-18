resource "bitbucket_workspace_variable" "bitbucket_variables" {
  for_each = tomap({
    for git_var in local.bitbucket_variables : "${git_var.key}_bitbucket_variable" => git_var
  })
  workspace  = "${each.value.workspace}"
  key        = each.value.key
  value      = each.value.value
  secured    = true
}