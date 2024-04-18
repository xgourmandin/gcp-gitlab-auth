# aws-workload-identity

a Terraform project to connect Bitbucket projects with AWS Security Token Service.\
This repository is not meant to be a Terraform module, but a starter project to connect your repositories with your AWS account.

Feel free to use it as a starting point. If you're making improvements on this, please consider making a pull request.

## Prerequisites

- A AWS account
- A Bitbucket repository (at least one, but this project is designed to handle multiple repositories)
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

## IAM Role condition

When you use an OpenID Connect (OIDC) identity provider (IdP), best practice is to limit the entities that can assume the role associated with the IAM IdP. To manage this, parameter `repository_filter_url` need to be set.

For the `repository_filter_url` variable the value need to be the Bitbucket workspace name.

### Configure your repository CI/CD

Once applied to your AWS account, use the following repository CI template to connect to your AWS account and start
making change to your infrastructure:

```yaml
pipelines:
  default:
    - step:
        name: auth
        oidc: true
        script:
          - export AWS_REGION=$sts_region_xxx
          - export AWS_ROLE_ARN=$sts_role_arn_xxx
          - export AWS_WEB_IDENTITY_TOKEN_FILE=web-identity-token
          - echo $BITBUCKET_STEP_OIDC_TOKEN > web-identity-token
          - aws sts get-caller-identity
```
