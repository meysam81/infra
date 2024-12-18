resource "random_password" "this" {
  length  = 32
  special = false
}

resource "github_repository_webhook" "this" {
  repository = "infra"

  configuration {
    url          = "https://fluxcd.developer-friendly.blog/hook/89d98a981541042cbf152c0718d0be57537f5a25afdf624609cdd91f2f48c07b"
    content_type = "json"
    insecure_ssl = false
    secret       = random_password.this.result
  }

  active = true

  events = [
    "push",
    "ping",
  ]
}

resource "aws_ssm_parameter" "webhook_secret" {
  name  = "/fluxcd/webhook-secret"
  type  = "SecureString"
  value = random_password.this.result
}
