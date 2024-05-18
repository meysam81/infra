locals {
  user_data = <<-EOF
    #cloud-config
    users:
      - name: meysam
        groups: users, admin, adm
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZnH6FYGZYs9dMVac351xJrngFqhRXMJoDBnCTe8+JA
      - name: k8s-oidc
        shell: /bin/false
    packages:
      - python3
      - python3-pip
    package_update: true
    package_upgrade: true
    runcmd:
      - |
        curl https://get.k3s.io | \
          INSTALL_K3S_VERSION="v1.30.0+k3s1" \
          INSTALL_K3S_EXEC="--cluster-cidr=20.0.0.0/8,2001:cafe:42::/56
            --kube-apiserver-arg=service-account-jwks-uri=https://meysam81.github.io/k8s-oidc-provider/openid/v1/jwks
            --kube-apiserver-arg=service-account-issuer=https://meysam81.github.io/k8s-oidc-provider
            --service-cidr=30.0.0.0/12,2001:cafe:43::/112
            --disable traefik
            --disable-network-policy
            --flannel-backend none
            --secrets-encryption" \
          sh -
      - |
        mkdir -p /home/meysam/.kube
        cp /etc/rancher/k3s/k3s.yaml /home/meysam/.kube/config
        chown -R meysam:meysam /home/meysam/.kube/
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

  user_data = local.user_data

  depends_on = [
    hcloud_network_subnet.this
  ]
}
