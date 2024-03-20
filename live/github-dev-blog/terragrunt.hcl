include "root" {
  path = find_in_parent_folders()
}

include "github" {
  path = find_in_parent_folders("provider_github.hcl")
}

include "aws" {
  path = find_in_parent_folders("provider_aws.hcl")
}

inputs = {
  gpg_key_emails = {
    "meysam@developer-friendly.blog" : "Meysam Azad"
  }
}
