/******************************************
  Locals
 *****************************************/

locals {

    location = var.regional ? var.region : var.zones[0]
    region   = var.regional ? var.region : join("-", slice(split("-", var.zones[0]), 0, 2))
    zone_count                  = length(var.zones)
    cluster_location = google_container_cluster.primary.location
    cluster_region   = var.regional ? var.region : join("-", slice(split("-", local.cluster_location), 0, 2))
    cluster_network_policy = var.network_policy ? [{
    enabled  = true
    provider = var.network_policy_provider
    }] : [{
    enabled  = false
    provider = null
  }]

    release_channel    = var.release_channel != null ? [{ channel : var.release_channel }] : []
    // Kubernetes version
    master_version_regional = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.region.latest_master_version
    master_version_zonal    = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.zone.latest_master_version
    master_version          = var.regional ? local.master_version_regional : local.master_version_zonal
    default_auto_upgrade = var.regional || var.release_channel != "UNSPECIFIED" ? true : false
    pod_all_ip_ranges         =  var.cluster_ipv4_cidr
    cluster_subnet_cidr = var.add_cluster_firewall_rules ? data.google_compute_subnetwork.gke_subnetwork[0].ip_cidr_range : null
    cluster_endpoint_for_nodes = var.master_ipv4_cidr_block
    node_locations = var.regional ? coalescelist(compact(var.zones), try(sort(random_shuffle.available_zones[0].result), [])) : slice(var.zones, 1, length(var.zones))
    node_pools         = { for np in var.node_pools : np.name => np } 
}