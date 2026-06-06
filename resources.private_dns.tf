resource "azurerm_private_dns_zone" "main" {
  count = lookup(var.db,"create_private_dns_zone",var.create_private_dns_zone_default) ? 1 : 0
  name                = lookup(var.db,"private_dns_zone_name","privatelink.mysql.database.azure.com")
  resource_group_name = var.db.resource_group
  tags                = lookup(var.db,"tags_dns",{})
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  count = lookup(var.db,"create_private_dns_zone",var.create_private_dns_zone_default) ? 1 : 0
  name                  = lookup(var.db,"vnet_link_name",format("%s-db-link",var.db.name))
  resource_group_name   = var.db.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.main[0].name
  virtual_network_id    = var.db.vnet_id
  tags                  = lookup(var.db,"tags_dns",{})
}

