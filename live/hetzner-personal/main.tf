data "aws_ssm_parameter" "this" {
  name = "/meysam/public-ip-address"
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
  server_type = "cax11"
  image       = "ubuntu-22.04"
  location    = "nbg1"

  network {
    network_id = hcloud_network.this.id
  }

  user_data = <<-EOF
    #include
    https://gist.github.com/meysam81/01f63f0cecddcf0d8dfaaefc451b8c14/raw/ca418cecec61f52a5a67c736ef6773f092de63db/config.yml
  EOF

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
    for_each = toset([22, 6443])
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
}

resource "hcloud_firewall_attachment" "this" {
  firewall_id = hcloud_firewall.this.id
  server_ids  = [hcloud_server.this.id]
}