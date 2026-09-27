# infra-pipeline

Terraform for the ECR repository used by the container projects, deployed by GitHub Actions.

## Flow

```text
pull request -> fmt + init + validate + plan -> plan posted as a PR comment
merge to main -> plan again -> wait for approval -> apply
```

## What you need

| Name | Type | Where | Purpose |
|---|---|---|---|
| `AWS_PLAN_ROLE_ARN` | secret | repository | Read-only role assumed via OIDC on pull requests |
| `AWS_APPLY_ROLE_ARN` | secret | `production` environment | Write role assumed via OIDC on `main` |

State lives in `s3://mr-devops-tfstate-<name>/gha-demo/terraform.tfstate`, versioned and encrypted, with S3-native locking (`use_lockfile = true`, Terraform >= 1.10).

## Decisions

- **Plan on PR, apply on main.** A pull request never gets credentials that can change anything.
- **Two roles.** The plan role is read-only; the apply role has only the permissions this stack needs. Neither is `AdministratorAccess`.
- **Approval gate.** The apply job targets a `production` GitHub Environment with required reviewers, so every change to real infrastructure has a named approver.
- **Concurrency: `cancel-in-progress: false`.** Applies queue rather than racing; cancelling a Terraform apply halfway through is how state gets corrupted.