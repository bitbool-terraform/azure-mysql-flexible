resource "azurerm_private_dns_zone" "main" {
  name                = format("%s.mysql.database.azure.com",var.name)
  resource_group_name = var.resource_group
  tags                = var.tags
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  resource_group_name = var.resource_group
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = format("%s-db-link",var.name)
  resource_group_name   = var.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
  tags                  = var.tags
}

