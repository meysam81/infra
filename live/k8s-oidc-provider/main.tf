locals {
  k8s_oidc_url  = "https://meysam81.github.io/k8s-oidc-provider"
  eso_namespace = "flux-system"
}

data "tls_certificate" "this" {
  url = local.k8s_oidc_url
}

resource "aws_iam_openid_connect_provider" "this" {
  url = local.k8s_oidc_url

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
      values   = ["system:serviceaccount:${local.eso_namespace}:external-secrets"]
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

resource "aws_ssm_parameter" "this" {
  name  = "/external-secrets/role-arn"
  type  = "String"
  value = aws_iam_role.this.arn
}
