locals {
    config_primary = lookup(var.db,"config",lookup(var.db,"config_primary",{}))

    config_replica = lookup(var.db,"config_replica",{})
}






