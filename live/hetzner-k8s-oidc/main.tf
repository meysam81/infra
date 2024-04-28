data "terraform_remote_state" "hetzner_personal" {
  backend = "remote"

  config = {
    hostname     = "app.terraform.io"
    organization = "meysam"
    workspaces = {
      name = "hetzner-personal"
    }
  }
}

locals {
  k8s_oidc_url = data.terraform_remote_state.hetzner_personal.outputs.server_hostname
}

data "tls_certificate" "this" {
  url = "https://${local.k8s_oidc_url}"
}

resource "aws_iam_openid_connect_provider" "this" {
  url = "https://${local.k8s_oidc_url}"

  # JWT token audience (aud)
  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.this.certificates[0].sha1_fingerprint
  ]
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.this.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.this.url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.this.url}:sub"
      values   = ["system:serviceaccount:external-secrets:external-secrets"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "external-secrets"
  assume_role_policy = data.aws_iam_policy_document.this.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
  ]
}
