output "ssh_private_key" {
  value     = tls_private_key.this.private_key_openssh
  sensitive = true
}

output "ssh_public_key" {
  value = trimspace(tls_private_key.this.public_key_openssh)
}

output "public_ip" {
  value = {
    ipv4 = hcloud_primary_ip.this["ipv4"].ip_address
    ipv6 = hcloud_primary_ip.this["ipv6"].ip_address
  }
  sensitive = true
}

output "cloudinit_config" {
  value     = hcloud_server.this.user_data
  sensitive = true
}

output "k3s_token" {
  value     = random_password.k3s_token.result
  sensitive = true
}
