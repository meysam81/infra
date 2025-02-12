data "cloudflare_zone" "this" {
  zone_id = "8fd8676956b357c88a1082d8dc91fb6f"
}

resource "github_repository" "this" {
  for_each = toset([
    "accounts",
    "photos",
    "auth",
    "cast",
  ])

  name = format("ente-%s", each.key)

  visibility = "public"

  vulnerability_alerts = true

  auto_init = true

  pages {
    build_type = "workflow"
    source {
      branch = "main"
      path   = "/"
    }
    cname = format("%s.meysam.io", each.key)
  }
}


resource "github_repository_file" "ci" {
  for_each = github_repository.this

  repository = each.value.name
  branch     = "main"
  file       = ".github/workflows/ci.yml"
  content = templatefile("${path.module}/files/ci.yml.tftpl", {
    build_target = each.key
  })
  commit_message      = "chore(CI): add pages deployment workflow"
  commit_author       = "opentofu[bot]"
  commit_email        = "opentofu[bot]@users.noreply.github.com"
  overwrite_on_create = true
}

resource "cloudflare_dns_record" "this" {
  for_each = github_repository.this

  zone_id = data.cloudflare_zone.this.zone_id
  content = "meysam81.github.io"
  name    = each.key
  proxied = false
  ttl     = 1
  type    = "CNAME"
}
