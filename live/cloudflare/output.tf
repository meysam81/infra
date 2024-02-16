output "account_id" {
  value = data.cloudflare_accounts.root.accounts[0].id
}

# output "zone_id" {
#   value = resource.cloudflare_zone.root.id
# }
