##################
## GITHUB LOCALS
##################
locals {
  # Define a list of prefixes for variables in Github
  github_variables_obj = [
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
  github_variables = flatten([
    for role in var.github_token == null ? [] : var.oidc_roles : [
      for project in role.repo_project_ids : [
        for var_obj in local.github_variables_obj : {
          name  = "${var_obj.name}${role.name != "default" ? "_${role.name}" : ""}_${var.environment}"
          repo  = project
          value = try(lookup(var_obj.val, "${role.name}_role").arn, var_obj.val)
        }
      ]
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
        arn = startswith(policy, "arn:") ? "${policy}" : "arn:aws:iam::aws:policy/${policy}"
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

  aws_web_identity_policy ={
    Version = "2012-10-17"
    Statement = [{
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        "Condition": {
          "StringLike": {
              "token.actions.githubusercontent.com:sub": "repo:${var.repository_filter_url}"
          },
          "StringEquals": {
              "token.actions.githubusercontent.com:aud": var.audience_url
          }
        }
        Principal = {
          "Federated": "arn:aws:iam::${var.aws_account_id}:oidc-provider/${local.aws_web_identity_principal}"
        }
      },
    ]
  }

  aws_web_identity_principal = "token.actions.githubusercontent.com"
}