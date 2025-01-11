
resource "hcloud_server" "this" {
  name        = "personal"
  image       = "ubuntu-24.04"
  server_type = "cax31"
  location    = "nbg1"

  keep_disk = true

  user_data = templatefile("templates/cloud-init.yml.tftpl", {
    ssh_public_key = tls_private_key.this.public_key_openssh,

    k3s_service_account_issuer   = var.github_pages_url
    k3s_service_account_jwks_uri = "${var.github_pages_url}/openid/v1/jwks"

    k3s_token = base64encode(random_password.k3s_token.result)

    server_public_ipv4 = hcloud_primary_ip.this["ipv4"].ip_address
    server_public_ipv6 = hcloud_primary_ip.this["ipv6"].ip_address
  })

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.this["ipv4"].id
    ipv6_enabled = true
    ipv6         = hcloud_primary_ip.this["ipv6"].id
  }

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }
}
