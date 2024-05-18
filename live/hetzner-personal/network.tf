resource "hcloud_network" "this" {
  name     = "personal"
  ip_range = "10.0.0.0/8"
}

resource "hcloud_network_subnet" "this" {
  type         = "cloud"
  network_id   = hcloud_network.this.id
  network_zone = "eu-central"
  ip_range     = "10.0.0.0/16"
}

resource "hcloud_primary_ip" "this" {
  for_each = toset(["ipv4", "ipv6"])

  name          = "${var.stack_name}-${each.key}"
  datacenter    = var.primary_ip_datacenter
  type          = each.key
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_firewall" "this" {
  name = "personal"
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "Allow ICMP i.e. ping"
  }

  dynamic "rule" {
    for_each = toset([80, 443])
    content {
      direction = "in"
      protocol  = "tcp"
      port      = rule.value
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
      description = "Allow HTTP and HTTPS from everywhere"
    }
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "any"
    source_ips = [
      data.aws_ssm_parameter.this.value,
    ]
    description = "Admin public IP address"
  }
}

resource "hcloud_firewall_attachment" "this" {
  firewall_id = hcloud_firewall.this.id
  server_ids  = [hcloud_server.this.id]

}
