include "root" {
  path = find_in_parent_folders("backend.hcl")
}

inputs = {
  github_private_key = dependency.oidc_repository.outputs.deploy_private_key
  github_pages_url   = dependency.oidc_repository.outputs.github_pages_url

  oidc_commit_name        = dependency.oidc_repository.outputs.commit_name
  oidc_commit_email       = dependency.oidc_repository.outputs.commit_email
  oidc_repo_name          = dependency.oidc_repository.outputs.repo_name
  oidc_repository_ssh_url = dependency.oidc_repository.outputs.repository_ssh_url

  gpg_private_key = dependency.gpg_key.outputs.gpg_private_key
}

dependency "oidc_repository" {
  config_path = "../k3s-issuer-pages-repo"
}

dependency "gpg_key" {
  config_path = "../k3s-issuer-gpg-key"
}
