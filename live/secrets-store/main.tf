resource "aws_ssm_parameter" "this" {
  for_each = { for p in var.parameters : p.name => p }

  name  = each.value.name
  value = each.value.value

  description = each.value.description

  type = each.value.secure ? "SecureString" : "String"

  tags = var.tags
}
