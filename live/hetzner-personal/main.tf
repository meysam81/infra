data "aws_ssm_parameter" "this" {
  name = "/meysam/public-ip-address"
}

data "cloudflare_zone" "devfriend_blog" {
  name = "developer-friendly.blog"
}

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

resource "hcloud_server" "this" {
  name        = "personal"
  server_type = "cax21"
  image       = "ubuntu-22.04"
  location    = "nbg1"

  network {
    network_id = hcloud_network.this.id
  }

  user_data = file("${path.module}/cloud-init.yml")

  depends_on = [
    hcloud_network_subnet.this
  ]
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

  dynamic "rule" {
    for_each = toset([22])
    content {
      direction = "in"
      protocol  = "tcp"
      port      = rule.value
      source_ips = [
        format("%s/32", data.aws_ssm_parameter.this.value),
      ]
      description = "Admin public IP address"
    }
  }

  rule {
    direction   = "in"
    protocol    = "tcp"
    port        = 80
    source_ips  = ["0.0.0.0/0"]
    description = "Allow HTTP from everywhere"
  }

  depends_on = [
    hcloud_server.this,
  ]
}

resource "hcloud_firewall_attachment" "this" {
  firewall_id = hcloud_firewall.this.id
  server_ids  = [hcloud_server.this.id]
}

resource "random_uuid" "this" {}

resource "cloudflare_record" "this" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = format("%s.developer-friendly.blog", random_uuid.this.id)
  proxied = false
  ttl     = 60
  type    = "A"
  value   = hcloud_server.this.ipv4_address
}


resource "cloudflare_record" "this_v6" {
  zone_id = data.cloudflare_zone.devfriend_blog.id

  name    = format("%s.developer-friendly.blog", random_uuid.this.id)
  proxied = false
  ttl     = 60
  type    = "AAAA"
  value   = hcloud_server.this.ipv6_address
}
