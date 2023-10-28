plan:
  cd {{invocation_directory()}} && terragrunt plan -out tfplan

apply:
  cd {{invocation_directory()}} && terragrunt apply tfplan
