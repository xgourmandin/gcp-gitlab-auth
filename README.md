# gcp-gitlab-auth

a Terraform project to connect Gitlab projects with GCP Workload Identity.\
This repository is not meant to be a Terraform module, but a starter project to connect your Gitlab repositories with your GCP project.

Feel free to use it as a starting point. If you're making improvements on this, please consider making a pull request.

## Prerequisites

- A GCP project
- A Gitlab repository (at least one, but this project is designed to handle multiple repositories)
- Permissions for your user in the GCP Project (Start with `role/editor` if you're not sure)

## Usage

### Apply the Terraform project

Make a copy of the `terraform.example.tfvars` file and name it `terraform.tfvars`. Fill in the required variables.

```bash
cp terraform.example.tfvars terraform.tfvars
```

To change/remove or add a backend, you can edit or add a file into the `backends` folder.

Then apply the Terraform project:

```bash
terraform init -backend-config="backends/backend_boxes_xxxx.hcl"
terraform apply
```

### Configure your Gitlab CI/CD

Once applied to your GCP project, use the following Gitlab CI template to connect to your GCP account and start
making change to your infrastructure:

```yaml
gcp-auth:
  image: google/cloud-sdk:slim
  script:
    - echo ${CI_JOB_JWT_V2} > .ci_job_jwt_file
    - gcloud iam workload-identity-pools create-cred-config ${workload_id_provider_id}
      --service-account="${service_account_email}"
      --output-file=.gcp_temp_cred.json
      --credential-source-file=.ci_job_jwt_file
    - gcloud auth login --cred-file=`pwd`/.gcp_temp_cred.json
    - gcloud auth list
```
