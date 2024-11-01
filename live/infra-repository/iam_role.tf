resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    data.tls_certificate.token_actions.certificates[0].sha1_fingerprint,
  ]
}

resource "aws_iam_role" "this" {
  name               = "ansible"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/IAMReadOnlyAccess",
  ]

  inline_policy {
    name   = "ansible"
    policy = data.aws_iam_policy_document.iam_policy.json
  }
}
