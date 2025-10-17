resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project}-monitor"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "la" {
  name                = "law-${var.project}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

output "la_id" { value = azurerm_log_analytics_workspace.la.id }
output "rg_name" { value = azurerm_resource_group.rg.name }
