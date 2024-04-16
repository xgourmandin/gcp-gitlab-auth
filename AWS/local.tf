locals {
  # Define a list of prefixes for variables in gitlab
  gitlab_variables_obj = [
    {
      name = "sts_audience_url",
      val = var.audience_url
    },
    {
      name = "sts_role_arn"
      val = aws_iam_role.roles
    },
    {
      name = "aws_account_id"
      val = var.aws_account_id
    }
  ]

  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  gitlab_variables = flatten([
    for role in var.oidc_roles : [
      for project in role.gitlab_project_ids : [
        for var_obj in local.gitlab_variables_obj : {
          key     = "${var_obj.name}${role.name != "default" ? "_${role.name}" : ""}_${var.environment}"
          project = project
          value   = try(lookup(var_obj.val, "${role.name}_role").arn, var_obj.val)
        }
      ]
    ]
  ])

  # define list of aws policies to attach to role
  aws_role_policies = flatten([
    for role in var.oidc_roles : [
      for policy in role.aws_policies == null ? [] : role.aws_policies : {
        arn = "arn:aws:iam::aws:policy/${policy}"
        name = role.name
      }
    ]
  ])

  # define list of customs policies to attach to role
  custom_role_policies = flatten([
    for role in var.oidc_roles : role.custom_policies == null ? [] : [
      {
        action = role.custom_policies
        name = role.name
      }
    ]
  ])
}