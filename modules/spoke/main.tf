resource "azurerm_resource_group" "spoke_rg" {
  name     = "rg-${var.project}-spoke"
  location = var.location
}

resource "azurerm_virtual_network" "spoke_vnet" {
  name                = "vnet-${var.project}-spoke"
  address_space       = [var.spoke_cidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke_rg.name
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.spoke_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_subnet" "data" {
  name                 = "snet-data"
  resource_group_name  = azurerm_resource_group.spoke_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = ["10.10.2.0/24"]
}

resource "azurerm_network_security_group" "nsg_common" {
  name                = "nsg-${var.project}-common"
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke_rg.name

  security_rule {
    name                       = "Allow-HTTP-80"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "app_assoc" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.nsg_common.id
}

resource "azurerm_subnet_network_security_group_association" "data_assoc" {
  subnet_id                 = azurerm_subnet.data.id
  network_security_group_id = azurerm_network_security_group.nsg_common.id
}

resource "azurerm_route_table" "rt_spoke" {
  name                = "rt-${var.project}-spoke"
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke_rg.name

  route {
    name                   = "default-to-fw"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_priv_ip
  }
}

resource "azurerm_subnet_route_table_association" "rt_app" {
  subnet_id      = azurerm_subnet.app.id
  route_table_id = azurerm_route_table.rt_spoke.id
}

resource "azurerm_subnet_route_table_association" "rt_data" {
  subnet_id      = azurerm_subnet.data.id
  route_table_id = azurerm_route_table.rt_spoke.id
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-${azurerm_virtual_network.spoke_vnet.name}-to-hub"
  resource_group_name       = azurerm_resource_group.spoke_rg.name
  virtual_network_name      = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id = var.hub_vnet_id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-${var.hub_vnet_name}-to-${azurerm_virtual_network.spoke_vnet.name}"
  resource_group_name       = var.hub_rg
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.spoke_vnet.id
  allow_forwarded_traffic   = true
}

output "rg_id" { value = azurerm_resource_group.spoke_rg.id }
output "rg_name" { value = azurerm_resource_group.spoke_rg.name }
output "vnet_name" { value = azurerm_virtual_network.spoke_vnet.name }
