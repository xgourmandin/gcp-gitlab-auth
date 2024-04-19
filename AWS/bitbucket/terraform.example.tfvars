aws_account_id = "123456789"
aws_region = "eu-west-3"
repository_provider_url = "https://api.bitbucket.org/2.0/workspaces/xxxxxxxxx/pipelines-config/identity/oidc"
repository_filter_url = "BitBucketWorkspaceName"
bitbucket_username = "MyUserName"
bitbucket_app_password = "AppPassword"
environment = "dev"
audience_url = "ari:cloud:bitbucket::workspace/xxxxxxxxxxxxxxxxxxxxxxxxxxx"
repository_thumbprint = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
oidc_roles = [
    {
        aws_policies = ["IAMFullAccess"]
        repo_project_ids = ["xxxxxxx", "yyyyyyy"] #repository UUID without brakets (within the same workspace)
        name = "default"
    },
    {
        aws_policies = ["PowerUserAccess", "IAMFullAccess"]
        custom_policies = ["rds:*"]
        repo_project_ids = ["xxxxxxx"] #repository UUID without brakets (within the same workspace)
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
        repo_project_ids = ["xxxxxxx", "zzzzzzz"] #repository UUID without brakets (within the same workspace)
        name = "docker"
    }
]