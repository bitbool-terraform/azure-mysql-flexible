resource "azurerm_mysql_flexible_server" "primary" {
  name                   = var.db.name
  resource_group_name    = var.db.resource_group
  location               = var.db.location
  administrator_login    = lookup(var.db,"admin_user",null)

  administrator_password_wo = lookup(var.db,"admin_pass_wo",null)
  administrator_password_wo_version = lookup(var.db,"admin_pass_wo_version",null)

  backup_retention_days  = lookup(var.db,"backup_retention_days", var.backup_retention_days_default)

  geo_redundant_backup_enabled = lookup(var.db,"geo_redundant_backup_enabled", var.geo_redundant_backup_enabled_default)

  public_network_access  = lookup(var.db,"public_network_access", var.public_network_access_default)

  delegated_subnet_id    = var.db.subnet_id
  private_dns_zone_id    = lookup(var.db,"create_private_dns_zone",var.create_private_dns_zone_default) ? azurerm_private_dns_zone.main[0].id : lookup(var.db,"private_dns_zone_id",null)

  sku_name               = lookup(var.db,"sku_name", var.sku_name_default)
  zone                   = lookup(var.db,"zone", var.zone_default)
  version                = lookup(var.db,"mysql_version", var.mysql_version_default)

  tags                   = lookup(var.db,"tags",{})

  dynamic "identity" {
    for_each = lookup(var.db,"identity_ids",null) == null ? [] : [var.db.identity_ids]
    content {
      type         = "UserAssigned"
      identity_ids = var.db.identity_ids
    }
  }

  dynamic "high_availability" {
    for_each = lookup(var.db,"high_availability",null) == null ? [] : [var.db.high_availability]
    content {
      mode = var.db.high_availability.mode
      standby_availability_zone = var.db.high_availability.standby_availability_zone
    }
  }

  lifecycle {
    ignore_changes = [
      administrator_login,
      administrator_password,
      administrator_password_wo,
      administrator_password_wo_version,
    ]
  }
}


resource "azurerm_mysql_flexible_server" "replica" {
  count = lookup(var.db,"replica_enabled",false) == true ? 1 : 0

  name                = lookup(var.db.replica,"name",format("%s%s",var.db.name,var.replica_suffix_default))
  resource_group_name = var.db.resource_group
  location            = var.db.location
  zone                = lookup(var.db.replica,"zone", var.zone_default)

  create_mode      = lookup(var.db.replica,"create_mode", null)
  source_server_id = azurerm_mysql_flexible_server.primary.id

  sku_name = try(var.db.replica.sku_name, lookup(var.db,"sku_name", var.sku_name_default))
  version  = lookup(var.db,"mysql_version", var.mysql_version_default)

  geo_redundant_backup_enabled = lookup(var.db.replica,"geo_redundant_backup_enabled", var.geo_redundant_backup_enabled_default)
  # dynamic "storage" {
  #   for_each = try(var.replica.storage, null) == null ? [] : [var.replica.storage]
  #   content {
  #     size_gb           = storage.value.size_gb
  #     iops              = storage.value.iops
  #     auto_grow_enabled = storage.value.auto_grow_enabled
  #   }
  # }

  tags = lookup(var.db,"tags",{})
}


resource "azurerm_mysql_flexible_server_configuration" "config_primary" {
  for_each = local.config_primary
  name                = each.key
  resource_group_name = var.db.resource_group
  server_name         = azurerm_mysql_flexible_server.primary.name
  value               = each.value
}

resource "azurerm_mysql_flexible_server_configuration" "config_replica" {
  for_each = local.config_replica
  name                = each.key
  resource_group_name = var.db.resource_group
  server_name         = azurerm_mysql_flexible_server.replica[0].name
  value               = each.value
}