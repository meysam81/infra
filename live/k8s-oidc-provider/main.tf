data "tls_certificate" "this" {
  for_each = var.oidc_issuer_urls

  url = each.value
}

resource "aws_iam_openid_connect_provider" "this" {
  for_each = data.tls_certificate.this

  url = each.value.url

  # JWT token audience (aud)
  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    each.value.certificates[0].sha1_fingerprint
  ]
}

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = aws_iam_openid_connect_provider.this
    content {
      actions = [
        "sts:AssumeRoleWithWebIdentity"
      ]

      effect = "Allow"

      principals {
        type        = "Federated"
        identifiers = [statement.value.arn]
      }

      condition {
        test     = "StringEquals"
        variable = "${statement.value.url}:aud"
        values   = ["sts.amazonaws.com"]
      }

      condition {
        test     = "StringEquals"
        variable = "${statement.value.url}:sub"
        values   = ["system:serviceaccount:external-secrets:external-secrets"]
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "external-secrets"
  assume_role_policy = data.aws_iam_policy_document.this.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
  ]
}

resource "aws_ssm_parameter" "this" {
  name  = "/external-secrets/role-arn"
  type  = "String"
  value = aws_iam_role.this.arn
}
