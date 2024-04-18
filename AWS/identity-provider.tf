resource "aws_iam_openid_connect_provider" "default" {
  url = var.repository_provider_url
  client_id_list = [var.audience_url]
  thumbprint_list = [var.repository_thumbprint]
}