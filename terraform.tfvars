project    = "lz"
location   = "eastus"
hub_cidr   = "10.0.0.0/16"
spoke_cidr = "10.10.0.0/16"
# subscription_id = "<your-subscription-id>"  # Prefer env: export TF_VAR_subscription_id=...

rbac = {
  hub_contributors   = []
  spoke_contributors = []
  readers            = []
}
