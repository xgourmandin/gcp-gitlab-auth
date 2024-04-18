# aws-workload-identity

a Terraform project to connect Github projects with AWS Security Token Service.\
This repository is not meant to be a Terraform module, but a starter project to connect your repositories with your AWS account.

Feel free to use it as a starting point. If you're making improvements on this, please consider making a pull request.

## Prerequisites

- A AWS account
- A Github repository (at least one, but this project is designed to handle multiple repositories)
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

When you use an OpenID Connect (OIDC) identity provider (IdP), best practice is to limit the entities that can assume the role associated with the IAM IdP. To manage this, two parameters need to be set `audience_url` and `repository_filter_url`.

For the `repository_filter_url` variable, there is multiple possibilities depending of the repostiory provider, below some examples :
 - "GitHubOrg/GitHubRepo:ref:refs/heads/GitHubBranch" --> for a specific branch filter
 - "GitHubOrg/GitHubRepo:environment:prod"            --> for a environnement filter
 - "GitHubOrg/GitHubRepo:*"                           --> for an organization and repository
 - "GitHubOrg/*"                                      --> for an organization

more informations : https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services

### Configure your repository CI/CD

Only Github Action are supported for the moment for the OIDC.
Once applied to your AWS account, use the following repository CI template to connect to your AWS account and start
making change to your infrastructure:

```yaml
name: AWS OICD test Workflow
on:
  push
env:
  AWS_REGION : ${{ vars.STS_REGION_XXX }}
# permission can be added at job level or workflow level
permissions:
  id-token: write   # This is required for requesting the JWT
  contents: read    # This is required for actions/checkout
jobs:
  STSCheck:
    runs-on: ubuntu-latest
    steps:
      - name: Git clone the repository
        uses: actions/checkout@v4
      - name: configure aws credentials
        uses: aws-actions/configure-aws-credentials@v3
        with:
          role-to-assume: ${{ vars.STS_ROLE_ARN_XXX }}
          role-session-name: GithubRunner-${{ github.repository_id }}-${{ github.run_id }}
          aws-region: ${{ env.AWS_REGION }}
      # Check STS credentials
      - name:  Check STS credentials
        run: |
          aws sts get-caller-identity
```