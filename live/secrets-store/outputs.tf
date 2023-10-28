output "parameters_version" {
  value = {
    for p in aws_ssm_parameter.this : p.arn => p.version
  }
}
