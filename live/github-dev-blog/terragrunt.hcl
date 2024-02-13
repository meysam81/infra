include "root" {
  path = find_in_parent_folders()
}

include "github" {
  path = find_in_parent_folders("provider_github.hcl")
}

inputs = {
  gpg_key_name  = "Meysam Azad"
  gpg_key_email = "meysam81@@users.noreply.github.com"

  repository = "blog"
}
