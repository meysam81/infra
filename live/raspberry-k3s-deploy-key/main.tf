resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 3072
}

resource "aws_ssm_parameter" "this" {
  name  = "/github/k8s-oidc-provider/deploy-key"
  type  = "SecureString"
  value = tls_private_key.this.private_key_pem
}

resource "github_repository_deploy_key" "this" {
  title      = "K8s OIDC Provider"
  repository = "k8s-oidc-provider"
  key        = tls_private_key.this.public_key_openssh
  read_only  = false
}
