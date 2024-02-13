resource "gpg_private_key" "this" {
  name       = var.gpg_key_name
  email      = var.gpg_key_email
  passphrase = var.gpg_key_passphrase
  rsa_bits   = var.gpg_key_rsa_bits
}

resource "github_user_gpg_key" "example" {
  provider = github.individual

  armored_public_key = gpg_private_key.this.public_key
}

resource "github_actions_secret" "this" {
  provider = github.individual

  for_each = {
    GPG_KEY_ID      = gpg_private_key.this.id
    GPG_PRIVATE_KEY = gpg_private_key.this.private_key
  }

  repository      = var.repository
  secret_name     = each.key
  plaintext_value = each.value
}
