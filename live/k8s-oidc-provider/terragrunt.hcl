include "root" {
  path = find_in_parent_folders("backend.hcl")
}

inputs = {
  oidc_issuer_url = dependency.oidc_url.outputs.github_pages_url
}

dependency "oidc_url" {
  config_path = "../k3s-issuer-pages-repo"
}
