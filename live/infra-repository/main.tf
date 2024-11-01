resource "github_branch_protection" "this" {
  repository_id = var.repository_name

  pattern          = "main"
  enforce_admins   = true
  allows_deletions = false

  force_push_bypassers = [
    "/meysam81",
  ]
}

resource "github_repository_environment" "this" {
  environment = var.environment_name
  repository  = var.repository_name

  prevent_self_review = false

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}

resource "github_actions_environment_secret" "iam_role" {
  repository = var.repository_name

  environment     = github_repository_environment.this.environment
  secret_name     = "AWS_IAM_ROLE"
  plaintext_value = aws_iam_role.this.arn
}

resource "github_actions_environment_variable" "aws_region" {
  repository  = var.repository_name
  environment = var.environment_name

  variable_name = "AWS_REGION"
  value         = data.aws_region.current.name
}

resource "github_actions_environment_secret" "aws_account_id" {
  repository = var.repository_name

  environment     = github_repository_environment.this.environment
  secret_name     = "AWS_ACCOUNT_ID"
  plaintext_value = data.aws_caller_identity.current.account_id
}
