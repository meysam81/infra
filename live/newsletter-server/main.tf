
resource "hcloud_server" "this" {
  name        = "personal"
  image       = "ubuntu-24.04"
  server_type = "cax11"
  location    = "nbg1"

  user_data = templatefile("templates/cloud-init.yml.tftpl", {
    ssh_public_key               = tls_private_key.this.public_key_openssh,
    k3s_service_account_issuer   = var.github_pages_url
    k3s_service_account_jwks_uri = "${var.github_pages_url}/openid/v1/jwks"
    k3s_version                  = var.k3s_version

    ssh_config         = base64encode(file("files/ssh-config"))
    ssh_known_hosts    = base64encode(file("files/ssh-known-hosts"))
    github_private_key = base64encode(var.github_private_key)

    gpg_private_key = base64encode(var.gpg_private_key)

    update_jwks_sh = base64encode(templatefile("templates/update-jwks.sh.tftpl", {
      repository_ssh_url = var.oidc_repository_ssh_url
      repo_name          = var.oidc_repo_name
      commit_name        = var.oidc_commit_name
      commit_email       = var.oidc_commit_email
    }))

    k3s_token = base64encode(random_password.k3s_token.result)

    server_public_ipv4 = hcloud_primary_ip.this["ipv4"].ip_address
    server_public_ipv6 = hcloud_primary_ip.this["ipv6"].ip_address

    update_jwks_service = base64encode(file("files/update-jwks.service"))
    update_jwks_timer   = base64encode(file("files/update-jwks.timer"))

    disk_device = hcloud_volume.this.linux_device
  })

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.this["ipv4"].id
    ipv6_enabled = true
    ipv6         = hcloud_primary_ip.this["ipv6"].id
  }
}

resource "hcloud_volume" "this" {
  name     = "personal"
  size     = 20
  location = "nbg1"
  format   = "xfs"
}


resource "hcloud_volume_attachment" "this" {
  volume_id = hcloud_volume.this.id
  server_id = hcloud_server.this.id
  automount = true
}
