resource "random_password" "this" {
  length  = 32
  special = false
}

resource "github_repository_webhook" "this" {
  repository = "infra"

  configuration {
    url          = "https://atlantis.developer-friendly.blog/events"
    content_type = "json"
    insecure_ssl = false
    secret       = random_password.this.result
  }

  active = true

  events = [
    "pull_request_review",
    "push",
    "issue_comment",
    "pull_request",
  ]
}

resource "aws_ssm_parameter" "webhook_secret" {
  name  = "/atlantis/webhook-secret"
  type  = "SecureString"
  value = random_password.this.result
}
