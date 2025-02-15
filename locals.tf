locals {


    location = var.regional ? var.region : var.zones[0]
    region   = var.regional ? var.region : join("-", slice(split("-", var.zones[0]), 0, 2))
    cluster_network_policy = var.network_policy ? [{
    enabled  = true
    provider = var.network_policy_provider
    }] : [{
    enabled  = false
    provider = null
  }]

    release_channel    = var.release_channel != null ? [{ channel : var.release_channel }] : []
    node_locations = var.regional ? coalescelist(compact(var.zones), try(sort(random_shuffle.available_zones[0].result), [])) : slice(var.zones, 1, length(var.zones))
}