include "root" {
  path = find_in_parent_folders("backend.hcl")
}

inputs = {
  role_arn = dependency.oidc_provider.outputs.role_arn
}


dependency "oidc_provider" {
  config_path = "../k8s-oidc-provider"
}
