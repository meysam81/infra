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
