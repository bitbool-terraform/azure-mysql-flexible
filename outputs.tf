output "fqdn" {
  value = azurerm_mysql_flexible_server.primary.fqdn
}

output "replica_fqdn" {
  value = try(azurerm_mysql_flexible_server.replica[0].fqdn, null)
}

output "name" {
  value = azurerm_mysql_flexible_server.primary.name
}

output "primary_id" {
  value = azurerm_mysql_flexible_server.primary.id
}

output "replica_id" {
  value = try(azurerm_mysql_flexible_server.replica[0].id,null)
}
