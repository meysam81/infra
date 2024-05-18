data "aws_ssm_parameter" "this" {
  name = "/meysam/public-ip-address"
}

resource "aws_ssm_parameter" "this" {
  name  = "/hetzner-personal/domain-name"
  type  = "String"
  value = format("%s.developer-friendly.blog", random_uuid.this.id)
}
