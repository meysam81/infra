include "root" {
  path = find_in_parent_folders()
}

include "aws" {
  path = find_in_parent_folders("provider_aws.hcl")
}

include "github" {
  path = find_in_parent_folders("provider_github.hcl")
}

inputs = {
}
