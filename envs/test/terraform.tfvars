project    = "lz-test"
location   = "eastus2"
hub_cidr   = "10.1.0.0/16"
spoke_cidr = "10.11.0.0/16"
environment = "test"

rbac = {
  hub_contributors   = []
  spoke_contributors = []
  readers            = []
}
