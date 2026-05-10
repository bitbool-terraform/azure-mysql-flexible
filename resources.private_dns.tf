resource "azurerm_private_dns_zone" "main" {
  name                = format("%s.private.mysql.database.azure.com",var.db.name)
  resource_group_name = var.db.resource_group
  tags                = lookup(var.db,"tags_dns",{})
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = lookup(var.db,"vnet_link_name",format("%s-db-link",var.db.name))
  resource_group_name   = var.db.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = var.db.vnet_id
  tags                  = lookup(var.db,"tags_dns",{})
}

