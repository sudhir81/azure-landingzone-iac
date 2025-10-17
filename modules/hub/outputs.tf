output "rg_id" { value = azurerm_resource_group.hub_rg.id }
output "rg_name" { value = azurerm_resource_group.hub_rg.name }
output "vnet_id" { value = azurerm_virtual_network.hub_vnet.id }
output "vnet_name" { value = azurerm_virtual_network.hub_vnet.name }
output "route_table_id" { value = azurerm_route_table.rt_to_fw.id }
output "firewall_private_ip" { value = azurerm_firewall.afw.ip_configuration[0].private_ip_address }
