output "log_analytics_workspace_id" { value = module.monitor.la_id }
output "hub_vnet" { value = module.hub.vnet_name }
output "spoke_vnet" { value = module.spoke_prod.vnet_name }
output "hub_rg" { value = module.hub.rg_name }
output "spoke_rg" { value = module.spoke_prod.rg_name }
