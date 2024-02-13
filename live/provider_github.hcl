generate "provider_github" {
  path      = "provider_github.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "github" {
      owner = "developer-friendly"
    }

    provider "github" {
      alias = "individual"

      owner = "meysam81"
    }
  EOF
}
