module "monitor" {
  source   = "./modules/monitor"
  project  = var.project
  location = var.location
}

module "hub" {
  source   = "./modules/hub"
  project  = var.project
  location = var.location
  hub_cidr = var.hub_cidr
  la_id    = module.monitor.la_id
}

module "spoke_prod" {
  source           = "./modules/spoke"
  project          = "${var.project}-prod"
  location         = var.location
  spoke_cidr       = var.spoke_cidr
  hub_vnet_id      = module.hub.vnet_id
  hub_vnet_name    = module.hub.vnet_name
  hub_rg           = module.hub.rg_name
  firewall_priv_ip = module.hub.firewall_private_ip
  route_table_id   = module.hub.route_table_id
}

module "policy" {
  source           = "./modules/policy"
  subscription_id  = var.subscription_id
  location         = var.location
  log_analytics_id = module.monitor.la_id
}

module "rbac" {
  source      = "./modules/rbac"
  hub_rg_id   = module.hub.rg_id
  spoke_rg_id = module.spoke_prod.rg_id
  rbac        = var.rbac
}
