variable "environment_name" {
  type    = string
  default = "prod"
}

variable "repository_name" {
  type    = string
  default = "infra"

}

variable "terraform_cloud_token" {
  type      = string
  sensitive = true
}
