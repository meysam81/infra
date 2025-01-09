data "aws_region" "this" {}

resource "kubernetes_annotations" "this" {
  api_version = "v1"
  kind        = "ServiceAccount"
  metadata {
    name      = "external-secrets"
    namespace = "external-secrets"
  }
  annotations = {
    "eks.amazonaws.com/audience" : "sts.amazonaws.com"
    "eks.amazonaws.com/role-arn" : var.role_arn
    "eks.amazonaws.com/sts-regional-endpoints" : "true"
    "eks.amazonaws.com/token-expiration" : "86400"
  }
}

resource "kubernetes_manifest" "this" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ClusterSecretStore"
    metadata = {
      name = "aws-parameter-store"
    }
    spec = {
      provider = {
        aws = {
          region  = data.aws_region.this.name
          service = "ParameterStore"
          auth = {
            jwt = {
              serviceAccountRef = {
                name      = "external-secrets"
                namespace = "external-secrets"
              }
            }
          }
        }
      }
    }
  }
  depends_on = [
    kubernetes_annotations.this
  ]
}
