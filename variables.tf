variable "db" {}

# db = {
#     name = 
#     resource_group =
#     location =
#     subnet_id
# }

# Defaults
variable "backup_retention_days_default" {default = 30 }
variable "replica_suffix_default" {default = "-ro" }
variable "geo_redundant_backup_enabled_default" {default = false }
variable "public_network_access_default" {default = "Disabled" }
variable "sku_name_default" {default = "GP_Standard_D2ds_v4"}
variable "zone_default" {default = null }
variable "mysql_version_default" {default = "8.0.21" }

variable "create_private_dns_zone_default" {default = true}