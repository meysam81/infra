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
  server_type = "cax21"
  image       = "ubuntu-22.04"
  location    = "nbg1"

  network {
    network_id = hcloud_network.this.id
  }

  public_net {
    ipv4 = hcloud_primary_ip.this["ipv4"].id
    ipv6 = hcloud_primary_ip.this["ipv6"].id
  }

  user_data = <<-EOF
    #cloud-config
    users:
      - name: meysam
        groups: users, admin, adm
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwSiqlfxWgquHAi8GB0XaqLSoy0/MTTENZQqoT0Y8USwOBanTRXSJiv5+BjvcvXsxzGC1Ap4+cVyWZ8CamSgrAWMjx+AEBELtzkHx94jD5MVZo/L7Uhz4LtwXPblNqiZPNxQOsbWFVO+Y6rl4bKfGoWGiJVzIL77Lnnn0ohtWfpvA/oIpd6HONOMOtVjOFtlAsvdFVnXTYoebhtZqWCCC8x/Bqk6zP8FTqPxh52E9/0bk6vtkFSeioQD0epxd2VUZjX9Djh1E05IdB77xtbLYot5GSFMHycyQ5EUHmsHy3so5oyZvlfAK0UipNxJxKnpfuTCJ62kg5vsOE0gYygB/cJIiZthXudv1i2fUWMdwunVxdDZd0w9L+jLv1az/rzOjwLEXkyNABKd7334s5PwkUwXo/0NYejRhjdGMW/nEzXrP3xM5SPbz8hJXVYi81BoUq3fFtQ6gDAcVZ1tU7WdbR09L5ceA6doa7gBrUhErqfMBoVkS+0TuZZtxVH32mxS8= meysam@meysam-asus
          - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0Ahbpsia1LsujDaUDD/JpTGWcykQfFpKjGzQzbB0zqL8hDPMg/VWZeJO0Pa0+x4GvYDeYREYIESblj7stEOR/VYRnje0O7NVmnCBEkoKvuqTyLODoY7FMqpd5jrw38SdZ7tiDGHOvpLVAv1xPklaLpId38gnS7ibGLUgbindY6x7zH5+C5+2cKeS0h5T572y1C71+g17N34QBYch271zf35EfAb/ocVNFLd27zyHX2mhLdvDfzIm6NK0V4kLmXkGZCxaHl3mZvzZ464Pdkwa+gFXY4FGn6InCMVsvH/qpDLfFxz47sBF5lBGlBbbYCPeOLjpGjRYnZwXfI40z84m5E3LjjQW95S3FWTgkUQXVpZSgAwKtx0oVvipRy7o8gOV+iB46btK1xifQ1I4/JbL1phuAng9lppNir3e5LfA9afJvDGiYmfoD5usiIPHRBB44Si+wXQz5XCeILfHDeq/LVohz3dKd7q2hl0IxxUd3Vfq6xA3eVdaEu3yW5X0DAR8TIpr+p8ht8UyM/PCTfAgCRWEPdJk+OJESz7b+V0fdgMafZ0hZVJPzBLrylm13rYQA4ux1896sl7Sd1s0C7ahyXi6IyY5vz6kyUdwGv+0LTgLhooBkPG75sWJ7JEQLvofT111LoIhlDs5sGEACu4HUw0Cc1YD29FPHI9D4m3dCsw== meysam@meysam-mac.local
    packages:
      - fail2ban
      - certbot
      - python3
      - python3-pip
    package_update: true
    package_upgrade: true
    runcmd:
      - printf "[sshd]\nenabled = true\nbanaction = iptables-multiport" > /etc/fail2ban/jail.local
      - systemctl enable fail2ban
      - sed -i -e '/^\(#\|\)PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
      - sed -i -e '/^\(#\|\)PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
      - sed -i -e '/^\(#\|\)KbdInteractiveAuthentication/s/^.*$/KbdInteractiveAuthentication no/' /etc/ssh/sshd_config
      - sed -i -e '/^\(#\|\)ChallengeResponseAuthentication/s/^.*$/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
      - sed -i -e '/^\(#\|\)MaxAuthTries/s/^.*$/MaxAuthTries 2/' /etc/ssh/sshd_config
      - sed -i -e '/^\(#\|\)X11Forwarding/s/^.*$/X11Forwarding no/' /etc/ssh/sshd_config
      - sed -i -e '/^\(#\|\)AllowAgentForwarding/s/^.*$/AllowAgentForwarding no/' /etc/ssh/sshd_config
      - sed -i -e '/^\(#\|\)AuthorizedKeysFile/s/^.*$/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config
      - sed -i '$a AllowUsers meysam' /etc/ssh/sshd_config
      - |
        curl https://get.k3s.io | \
          INSTALL_K3S_VERSION="v1.29.4+k3s1" \
          INSTALL_K3S_EXEC="--cluster-cidr=20.0.0.0/8,2001:cafe:42::/56
            --kube-apiserver-arg=service-account-jwks-uri=https://${cloudflare_record.this["A"].name}/openid/v1/jwks
            --kube-apiserver-arg=service-account-issuer=https://${cloudflare_record.this["A"].name}
            --service-cidr=30.0.0.0/12,2001:cafe:43::/112
            --disable traefik
            --disable-network-policy
            --flannel-backend none
            --write-kubeconfig /home/meysam/.kube/config
            --secrets-encryption" \
          sh -
      - chown -R meysam:meysam /home/meysam/.kube/
      - kubectl completion bash | tee /etc/bash_completion.d/kubectl
      - k3s completion bash | tee /etc/bash_completion.d/k3s
      - |
        cat << 'EOF2' >> /home/meysam/.bashrc
        alias k=kubectl
        complete -F __start_kubectl k
        EOF2
      - |
        CILIUM_CLI_VERSION=v0.16.4
        CILIUM_VERSION=1.15.4
        CLI_ARCH=arm64
        curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/$CILIUM_CLI_VERSION/cilium-linux-$CLI_ARCH.tar.gz{,.sha256sum}
        sha256sum --check cilium-linux-$CLI_ARCH.tar.gz.sha256sum
        tar xzvf cilium-linux-$CLI_ARCH.tar.gz -C /usr/local/bin/
      - reboot
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
      format("%s/32", data.aws_ssm_parameter.this.value),
    ]
    description = "Admin public IP address"
  }
}

resource "hcloud_primary_ip" "this" {
  for_each = toset(["ipv4", "ipv6"])

  name          = "${var.stack_name}-${each.key}"
  datacenter    = var.primary_ip_datacenter
  type          = each.key
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_firewall_attachment" "this" {
  firewall_id = hcloud_firewall.this.id
  server_ids  = [hcloud_server.this.id]

}

resource "aws_ssm_parameter" "this" {
  name  = "/hetzner-personal/domain-name"
  type  = "String"
  value = format("%s.developer-friendly.blog", random_uuid.this.id)
}
