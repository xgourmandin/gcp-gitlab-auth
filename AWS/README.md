# gitlab-aws-workload-identity

a Terraform project to connect Gitlab projects with AWS Security Token Service.\
This repository is not meant to be a Terraform module, but a starter project to connect your Gitlab repositories with your AWS account.

Feel free to use it as a starting point. If you're making improvements on this, please consider making a pull request.

## Prerequisites

- A AWS account
- A Gitlab repository (at least one, but this project is designed to handle multiple repositories)
- Permissions for your user in the AWS account (Start with `IAMFullAccess` if you're not sure)

## Usage

### Apply the Terraform project

Make a copy of the `terraform.example.tfvars` file and name it `terraform.tfvars`. Fill in the required variables.

```bash
cp terraform.example.tfvars terraform.tfvars
```

To change/remove or add a backend, you can edit or add a file into the `backends` folder.

Then apply the Terraform project:

```bash
terraform init -backend-config="backends/backend_xxxx.hcl"
terraform apply
```

### Configure your Gitlab CI/CD

Once applied to your AWS account, use the following Gitlab CI template to connect to your AWS account and start
making change to your infrastructure:

```yaml
aws-auth:
  image: registry.gitlab.com/gitlab-org/cloud-deploy/aws-base:latest
  id_tokens:
    GITLAB_OIDC_TOKEN:
      aud: https://xxxx.com #${sts_audience_url_XXXX} using variable for id_tokens is not supported yet https://gitlab.com/gitlab-org/gitlab/-/issues/426552
  script:
    - STS=$(aws sts assume-role-with-web-identity
      --role-arn ${sts_role_arn_XXXX}
      --role-session-name "GitLabRunner-${CI_PROJECT_ID}-${CI_PIPELINE_ID}"
      --web-identity-token "${GITLAB_OIDC_TOKEN}"
      --duration-seconds 3600 )
    - export AWS_ACCESS_KEY_ID=$(echo ${STS} | jq -r .Credentials.AccessKeyId)
    - export AWS_SECRET_ACCESS_KEY=$(echo ${STS} | jq -r .Credentials.SecretAccessKey)
    - export AWS_SESSION_TOKEN=$(echo ${STS} | jq -r .Credentials.SessionToken)
    - aws sts get-caller-identity
```