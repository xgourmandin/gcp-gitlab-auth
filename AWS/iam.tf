resource "aws_iam_role" "default" {
  name = "oidc_gitlab_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        "Condition": {
            "StringEquals": {
                "gitlab.com:aud": [
                    var.audience_url
                ]
            }
        }
        Principal = {
          "Federated": "arn:aws:iam::${var.aws_account_id}:oidc-provider/${replace(var.gitlab_url,"https://","")}"
        }
      },
    ]
  })
}

data "aws_iam_policy" "existing_aws_policy" {
  for_each = toset(var.aws_account_policies)
  arn = "arn:aws:iam::aws:policy/${each.key}"
}

resource "aws_iam_role_policy_attachment" "sto-readonly-role-policy-attach" {
  for_each   = data.aws_iam_policy.existing_aws_policy
  role       = "${aws_iam_role.default.name}"
  policy_arn = "${each.value.arn}"
}

resource "aws_iam_policy" "policy_oidc" {
  count = var.sa_account_policies == null ? 0 : 1
  name = "policy-oidc-gitlab"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = var.sa_account_policies
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "custom-role-policies" {
  count = var.sa_account_policies == null ? 0 : 1
  role       = "${aws_iam_role.default.name}"
  policy_arn = aws_iam_policy.policy_oidc[0].arn
}