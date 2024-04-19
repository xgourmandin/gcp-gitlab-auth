##################
## BITBUCKET LOCALS
##################
locals {
  # Define a list of prefixes for variables in Bitbucket
  bitbucket_variables_obj = [
    {
      name = "sts_region",
      val = var.aws_region
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
  bitbucket_variables = flatten([
    for role in var.bitbucket_username == null ? [] : var.oidc_roles : [
      for var_obj in local.bitbucket_variables_obj : {
        key  = "${var_obj.name}${role.name != "default" ? "_${role.name}" : ""}_${var.environment}"
        workspace  = var.repository_filter_url #filter is the workspace
        value = try(lookup(var_obj.val, "${role.name}_role").arn, var_obj.val)
      }
    ]
  ])
}

##################
## COMMON LOCALS
##################
locals {
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

  # create  a map for each roles of repositories
  # this enable a fine-grained filter for IAM role
  aws_repository_filter = tomap({for role in var.oidc_roles :
    role.name => [for project in role.repo_project_ids :
      "{${project}}:*"
    ]
  })
}