include "root" {
  path = find_in_parent_folders()
}

include "aws" {
  path = find_in_parent_folders("provider_aws.hcl")
}

include "cloudflare" {
  path = find_in_parent_folders("provider_cloudflare.hcl")
}

inputs = {
  target_email_address = "meysamazad81@gmail.com"
}
