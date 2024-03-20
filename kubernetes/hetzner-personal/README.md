# How to setup

```bash
kustomize build https://github.com/meysam81/infra//kubernetes/hetzner-personal/flux-system/?ref=main | k apply -f -
kubectl apply -f https://raw.githubusercontent.com/meysam81/infra/main/kubernetes/hetzner-personal/main.yml
```
