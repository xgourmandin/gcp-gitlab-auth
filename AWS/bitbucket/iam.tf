resource "aws_iam_role" "roles" {
  for_each = tomap({
    for roles in var.oidc_roles : "${roles.name}_role" => roles
  })
  name = "oidc_${each.value.name}_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        "Condition": {
          "StringLike": {
            "api.bitbucket.org/2.0/workspaces/${var.repository_filter_url}/pipelines-config/identity/oidc:sub": local.aws_repository_filter[each.value.name]
          }
        }
        Principal = {
          "Federated": "arn:aws:iam::${var.aws_account_id}:oidc-provider/api.bitbucket.org/2.0/workspaces/${var.repository_filter_url}/pipelines-config/identity/oidc"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sto-readonly-role-policy-attach" {
  for_each   = tomap({
    for index, aws_pol in local.aws_role_policies : "aws_policy_${split("/",aws_pol.arn)[1]}_${index}" => aws_pol
  })
  role       = "oidc_${each.value.name}_role"
  policy_arn = "${each.value.arn}"
  depends_on = [ aws_iam_role.roles ]
}

resource "aws_iam_policy" "policy_oidc" {
  for_each = tomap({
    for custom_policies in local.custom_role_policies : "${custom_policies.name}_custom_policy" => custom_policies
  })
  name = "policy-oidc-${each.value.name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = each.value.action
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "custom-role-policies" {
  for_each   = aws_iam_policy.policy_oidc
  role       = "oidc_${split("-", each.value.name)[2]}_role"
  policy_arn = each.value.arn

  depends_on = [ aws_iam_role.roles ]
}