output "ssh_private_key" {
  value     = tls_private_key.this.private_key_openssh
  sensitive = true
}

output "ssh_public_key" {
  value = tls_private_key.this.public_key_openssh
}

output "volume_location" {
  value = hcloud_volume.this.location
}

output "volume_device" {
  value = hcloud_volume.this.linux_device
}

output "public_ip" {
  value = {
    ipv4 = hcloud_primary_ip.this["ipv4"].ip_address
    ipv6 = hcloud_primary_ip.this["ipv6"].ip_address
  }
}

output "cloudinit_config" {
  value     = hcloud_server.this.user_data
  sensitive = true
}
