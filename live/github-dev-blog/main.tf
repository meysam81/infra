resource "gpg_private_key" "this" {
  for_each = var.gpg_key_emails

  name       = each.value
  email      = each.key
  passphrase = var.gpg_key_passphrase
  rsa_bits   = var.gpg_key_rsa_bits
}

# resource "github_user_gpg_key" "this" {
#   for_each = var.gpg_key_emails

#   provider = github.individual

#   armored_public_key = gpg_private_key.this[each.key].public_key
# }

resource "aws_ssm_parameter" "this" {
  for_each = var.gpg_key_emails

  name  = format("/github/gpg-private-keys/%s", replace(each.key, "/[@\\.]/", "-"))
  value = gpg_private_key.this[each.key].private_key
  type  = "SecureString"
}
