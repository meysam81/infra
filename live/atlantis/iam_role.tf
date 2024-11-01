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

resource "aws_ssm_parameter" "role_arn" {
  name  = "/atlantis/aws-role-arn"
  type  = "String"
  value = aws_iam_role.this.arn
}
