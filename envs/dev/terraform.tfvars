project    = "lz-dev"
location   = "eastus"
hub_cidr   = "10.0.0.0/16"
spoke_cidr = "10.10.0.0/16"
environment = "dev"

rbac = {
  hub_contributors   = []
  spoke_contributors = []
  readers            = []
}
