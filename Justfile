[no-cd]
init *args:
  terragrunt init -upgrade {{args}}

[no-cd]
validate:
  terragrunt validate

[no-cd]
plan *args:
  terragrunt plan -out tfplan {{args}}

[no-cd]
apply:
  terragrunt apply tfplan

lint:
  pre-commit run -a

fmt:
  tofu fmt -write -recursive
  terragrunt run-all hclfmt --terragrunt-non-interactive

sort-blocklist-ips:
  sort -u ansible/newsletter-server/blocklist_ips.lst -o ansible/newsletter-server/blocklist_ips.lst

[no-cd]
tflint-fix:
  tflint --fix --chdir=.

checkov:
  checkov --config-file .checkov_config.yaml -d .

create-tofu-stack dirname:
  #!/usr/bin/env bash

  mkdir -p live/{{dirname}}
  touch live/{{dirname}}/{main,versions,variables,outputs}.tf
  touch live/{{dirname}}/terragrunt.hcl

  cat <<'EOF' > live/{{dirname}}/terragrunt.hcl
  include "root" {
    path = find_in_parent_folders()
  }
  EOF
