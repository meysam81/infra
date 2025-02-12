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

[no-cd]
output *args:
  terragrunt output {{args}}

lint:
  pre-commit run -a

reconcile-k8s:
  kubectl apply -f kubernetes/newsletter-server/gitops/

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

[no-cd]
create-tofu-stack dirname:
  #!/usr/bin/env bash

  mkdir -p {{dirname}}
  touch {{dirname}}/{main,versions,variables,outputs}.tf
  touch {{dirname}}/terragrunt.hcl

  cat <<'EOF' > {{dirname}}/terragrunt.hcl
  include "backend" {
    path = find_in_parent_folders("backend.hcl")
  }

  inputs = {
  }
  EOF

role-init roleName:
  #!/usr/bin/env sh

  cd ansible
  ansible-galaxy init roles/{{roleName}}
