valkey_on_aks

Manual terraform run

Use `az login` to login to Azure with a user

```pwsh
az login --service-principal -u <infradeployspnappid> -p <infradeployspnapppwd> --tenant <tenant id>
az account set --subscription <subscriptionid>
```

Use below commands to run terraform.

```
terraform init -upgrade -backend-config='backends/poc_valkey_on_aks.local.cfg'
terraform plan -out='valkey_on_aks.tfplan' -var-file='env.local.tfvars'
terraform apply valkey_on_aks.tfplan
```