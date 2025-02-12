include "backend" {
  path = find_in_parent_folders("backend.hcl")
}

include "github" {
  path = find_in_parent_folders("github.hcl")
}

inputs = {
}
