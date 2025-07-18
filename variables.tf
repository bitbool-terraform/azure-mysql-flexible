variable "name" {}
variable "resource_group" {}
variable "location" {}
variable "admin_user" {}
variable "admin_pass" {}

variable "vnet" {}
variable "subnet" {}

variable "backup_retention_days" {default = 30 }
variable "geo_redundant_backup_enabled" {default = false }
variable "public_network_access" {default = "Disabled" }

variable "sku_name" {default = "GP_Standard_D2ds_v4"}

variable "mysql_version" {default = "8.0.21" }
variable "tags" {default = null }
variable "zone" {default = null }

