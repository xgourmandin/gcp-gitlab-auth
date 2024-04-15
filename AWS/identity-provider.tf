resource "aws_iam_openid_connect_provider" "default" {
  url = var.gitlab_url
  client_id_list = [var.audience_url]
  thumbprint_list = [var.gitlab_thumbprint]
}