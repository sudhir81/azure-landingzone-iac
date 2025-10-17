## Run
az login
az account set --subscription "<SUB>"
export TF_VAR_subscription_id="<SUB>"

terraform init -backend-config=backend.hcl
terraform validate
terraform plan -out plan.tfplan
terraform apply plan.tfplan
