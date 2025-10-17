project    = "lz-prod"
location   = "centralus"
hub_cidr   = "10.2.0.0/16"
spoke_cidr = "10.12.0.0/16"
environment = "prod"

rbac = {
  hub_contributors   = []
  spoke_contributors = []
  readers            = []
}
