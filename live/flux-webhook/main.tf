data "kubernetes_resource" "receiver" {
  api_version = "notification.toolkit.fluxcd.io/v1"
  kind        = "Receiver"

  metadata {
    name      = "github-receiver"
    namespace = "flux-system"
  }
}

resource "random_password" "this" {
  length  = 32
  special = false
}

resource "github_repository_webhook" "this" {
  repository = "infra"

  configuration {
    url          = format("https://fluxcd.developer-friendly.blog%s", data.kubernetes_resource.receiver.object.status.webhookPath)
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
