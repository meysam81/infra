data "tls_certificate" "oidc_thumbprint" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:meysam81/infra:environment:${var.environment_name}"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "iam_policy" {
  statement {
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:PutRolePolicy",
      "iam:AttachRolePolicy",
      "iam:CreateOpenIDConnectProvider",
      "iam:TagRole"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:PutParameter"
    ]
    resources = ["arn:aws:ssm:*:*:parameter/*"]
  }
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    data.tls_certificate.oidc_thumbprint.certificates[0].sha1_fingerprint,
  ]
}

resource "aws_iam_role" "this" {
  name               = "meysam81-infra"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
  ]

  inline_policy {
    name   = "meysam81-infra"
    policy = data.aws_iam_policy_document.iam_policy.json
  }
}
