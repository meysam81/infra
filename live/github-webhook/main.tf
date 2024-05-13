data "aws_ssm_parameter" "this" {
  name = "/github/developer-friendly/blog/flux-system/receiver/token"
}

resource "github_repository_webhook" "this" {
  provider = github.individual

  repository = "infra"

  configuration {
    url          = "https://7c75a749-765a-c643-21de-1257a0758748.developer-friendly.blog"
    content_type = "json"
    insecure_ssl = false
    secret       = data.aws_ssm_parameter.this.value
  }

  active = true

  events = ["push", "ping"]
}
