resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "hcloud_ssh_key" "this" {
  name       = "personal"
  public_key = tls_private_key.this.public_key_openssh
}
