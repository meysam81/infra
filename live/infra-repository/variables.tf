variable "environment_name" {
  type    = string
  default = "prod"
}

variable "repository_name" {
  type    = string
  default = "infra"

}

variable "oidc_issuer_url" {
  type     = string
  nullable = false
}
