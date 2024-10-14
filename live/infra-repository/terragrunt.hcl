include "root" {
  path = find_in_parent_folders()
}

inputs = {
  oidc_issuer_url = dependency.issuer_pages_repo.outputs.github_pages_url
}

dependency "issuer_pages_repo" {
  config_path = "../k3s-issuer-pages-repo"
}
