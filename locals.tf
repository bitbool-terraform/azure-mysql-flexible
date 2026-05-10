locals {
    config_primary = lookup(var.db,"replica_enabled",false) == false ? lookup(var.db,"config",{}) : try(lookup(var.db.config,"primary",{}),{})

    config_replica = lookup(var.db,"replica_enabled",false) == true ? try(lookup(var.db.config,"replica",{}),{}) : {}
}