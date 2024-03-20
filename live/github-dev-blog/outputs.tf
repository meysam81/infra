output "gpg_private_keys" {
  value = {
    for email, title in var.gpg_key_emails : email => gpg_private_key.this[email].private_key
  }
  sensitive = true
}

output "gpg_public_keys" {
  value = {
    for email, title in var.gpg_key_emails : email => gpg_private_key.this[email].public_key
  }
}
