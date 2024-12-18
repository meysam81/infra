variable "github_pages_url" {
  type     = string
  nullable = false
}

variable "k3s_version" {
  type    = string
  default = "v1.30.4+k3s1"
}

variable "oidc_commit_name" {
  type     = string
  nullable = false
}

variable "oidc_commit_email" {
  type     = string
  nullable = false
}

variable "oidc_repo_name" {
  type     = string
  nullable = false
}

variable "oidc_repository_ssh_url" {
  type     = string
  nullable = false
}

variable "github_private_key" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "gpg_private_key" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
  nullable  = false
}
