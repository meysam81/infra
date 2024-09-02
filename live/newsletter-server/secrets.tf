resource "random_password" "k3s_token" {
  length  = 32
  special = false
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "this" {
  name       = "personal"
  public_key = tls_private_key.this.public_key_openssh
}
