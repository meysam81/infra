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

check:
  pre-commit run -a

fmt:
  tofu fmt -write -recursive
  terragrunt run-all hclfmt --terragrunt-non-interactive

sort-blocklist-ips:
  sort -u ansible/newsletter-server/blocklist_ips.lst -o ansible/newsletter-server/blocklist_ips.lst

[no-cd]
tflint-fix:
  tflint --fix --chdir=.
