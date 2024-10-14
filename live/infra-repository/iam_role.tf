data "aws_iam_openid_connect_provider" "this" {
  url = var.oidc_issuer_url
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.this.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${data.aws_iam_openid_connect_provider.this.url}:sub"
      values   = ["system:serviceaccount:atlantis:atlantis"]
    }

    condition {
      test     = "StringEquals"
      variable = "${data.aws_iam_openid_connect_provider.this.url}:aud"
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

resource "aws_iam_role" "this" {
  name               = "atlantis"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/IAMReadOnlyAccess",
  ]

  inline_policy {
    name   = "atlantis"
    policy = data.aws_iam_policy_document.iam_policy.json
  }
}

resource "aws_ssm_parameter" "this" {
  name  = "/atlantis/aws-role-arn"
  type  = "String"
  value = aws_iam_role.this.arn
}
