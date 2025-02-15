locals {


    location = var.regional ? var.region : var.zones[0]
    region   = var.regional ? var.region : join("-", slice(split("-", var.zones[0]), 0, 2))
    zone_count                  = length(var.zones)
    cluster_network_policy = var.network_policy ? [{
    enabled  = true
    provider = var.network_policy_provider
    }] : [{
    enabled  = false
    provider = null
  }]

    release_channel    = var.release_channel != null ? [{ channel : var.release_channel }] : []
    node_locations = var.regional ? coalescelist(compact(var.zones), try(sort(random_shuffle.available_zones[0].result), [])) : slice(var.zones, 1, length(var.zones))
    // Kubernetes version
    master_version_regional = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.region.latest_master_version
    master_version_zonal    = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.zone.latest_master_version
    master_version          = var.regional ? local.master_version_regional : local.master_version_zonal
    default_auto_upgrade = var.regional || var.release_channel != "UNSPECIFIED" ? true : false
    cluster_network_tag                        = "gke-${var.name}"
    cluster_alias_ranges_cidr = var.add_cluster_firewall_rules ? { for range in toset(data.google_compute_subnetwork.gke_subnetwork[0].secondary_ip_range) : range.range_name => range.ip_cidr_range } : {}
    pod_all_ip_ranges         =  "var.cluster_ipv4_cidr"
}