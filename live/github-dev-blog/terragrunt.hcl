include "root" {
  path = find_in_parent_folders()
}

include "github" {
  path = find_in_parent_folders("provider_github.hcl")
}

inputs = {
  gpg_key_name_email = {
    "meysam@developer-friendly.blog" : "Meysam Azad"
  }
}
