resource "hcloud_network" "this" {
  name     = "personal"
  ip_range = "172.16.0.0/16"
}

resource "hcloud_network_subnet" "this" {
  network_id   = hcloud_network.this.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = cidrsubnets(hcloud_network.this.ip_range, 4, 4)[1]
}

resource "hcloud_server_network" "this" {
  server_id  = hcloud_server.this.id
  network_id = hcloud_network.this.id
}

resource "hcloud_primary_ip" "this" {
  for_each = toset(["ipv4", "ipv6"])

  name          = "personal-${each.key}"
  type          = each.key
  datacenter    = "nbg1-dc3"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_firewall" "this" {
  name = "personal"

  rule {
    direction = "in"
    protocol  = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    port = "80"
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
    port = "443"
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
    port = "10113"
  }
}

resource "hcloud_firewall_attachment" "this" {
  firewall_id = hcloud_firewall.this.id
  server_ids = [
    hcloud_server.this.id
  ]
}
