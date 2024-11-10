resource "random_password" "this" {
  length  = 32
  special = false
}

resource "github_repository_webhook" "this" {
  repository = "infra"

  configuration {
    url          = "https://fluxcd.developer-friendly.blog/events"
    content_type = "json"
    insecure_ssl = false
    secret       = random_password.this.result
  }

  active = true

  events = [
    "push",
  ]
}

resource "aws_ssm_parameter" "webhook_secret" {
  name  = "/fluxcd/webhook-secret"
  type  = "SecureString"
  value = random_password.this.result
}
