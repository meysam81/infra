output "gpg_private_keys" {
  value = {
    for email, title in var.gpg_key_emails : email => gpg_private_key.this[title].private_key
  }
  sensitive = true
}
