variable "oidc_issuer_urls" {
  type     = set(string)
  nullable = false
  default  = ["https://k8s.developer-friendly.blog"]
}
