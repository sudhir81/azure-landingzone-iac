resource "azurerm_resource_group" "hub_rg" {
  name     = "rg-${var.project}-hub"
  location = var.location
}

resource "azurerm_virtual_network" "hub_vnet" {
  name                = "vnet-${var.project}-hub"
  address_space       = [var.hub_cidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_rg.name
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.1.0/26"]
}

resource "azurerm_public_ip" "fw_pip" {
  name                = "pip-${var.project}-afw"
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "afw" {
  name                = "afw-${var.project}"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }
}

resource "azurerm_route_table" "rt_to_fw" {
  name                = "rt-${var.project}-to-fw"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  route {
    name                   = "default-to-fw"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.afw.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_monitor_diagnostic_setting" "afw_diag" {
  name                       = "diag-afw"
  target_resource_id         = azurerm_firewall.afw.id
  log_analytics_workspace_id = var.la_id

  enabled_log { category = "AzureFirewallApplicationRule" }
  enabled_log { category = "AzureFirewallNetworkRule" }
  enabled_log { category = "AzureFirewallDnsProxy" }
}
