aws_account_id = "123456789"
aws_region = "eu-west-3"
gitlab_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
environment = "dev"
audience_url = "https://xxxxxxx.com"
gitlab_thumbprint = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
oidc_roles = [
    {
        aws_policies = ["IAMFullAccess"]
        gitlab_project_ids = ["xxxxxxx"]
        name = "default"
    },
    {
        aws_policies = ["PowerUserAccess", "IAMFullAccess"]
        custom_policies = ["rds:*"]
        gitlab_project_ids = ["xxxxxxx"]
        name = "terraform"
    },
    {
        custom_policies = ["ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:PutImage",
                "ecs:*"]
        gitlab_project_ids = ["xxxxxxx"]
        name = "docker"
    }
]