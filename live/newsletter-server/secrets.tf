resource "random_password" "k3s_token" {
  length  = 32
  special = false
}

resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "hcloud_ssh_key" "this" {
  name       = "personal"
  public_key = tls_private_key.this.public_key_openssh
}

resource "aws_ssm_parameter" "ssh_private_key" {
  name  = "/newsletter-server/ssh-private-key"
  type  = "SecureString"
  value = tls_private_key.this.private_key_openssh
}
