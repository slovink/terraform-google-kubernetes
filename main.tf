module "labels" {
  source  = "git::https://github.com/slovink/terraform-google-labels.git"

  name        = var.name
  environment = var.environment
  label_order = var.label_order
}

/******************************************
  Create Container Cluster
 *****************************************/

resource "google_container_cluster" "primary" {
  count = var.google_container_cluster_enabled && var.module_enabled ? 1 : 0

  name     = module.labels.id
  location = var.location
  project            = var.project_id
  network                  = var.network
  subnetwork               = var.subnetwork
  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = var.initial_node_count
  cluster_ipv4_cidr   = var.cluster_ipv4_cidr
  min_master_version = var.release_channel == null || var.release_channel == "UNSPECIFIED" ? local.master_version : var.kubernetes_version == "latest" ? null : var.kubernetes_version
  deletion_protection = var.deletion_protection

  dynamic "release_channel" {
    for_each = local.release_channel

    content {
      channel = release_channel.value.channel
    }
  }

  dynamic "network_policy" {
    for_each = local.cluster_network_policy

    content {
      enabled  = network_policy.value.enabled
      provider = network_policy.value.provider
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.enable_private_nodes ? [{
      enable_private_nodes        = var.enable_private_nodes,
      enable_private_endpoint     = var.enable_private_endpoint
      master_ipv4_cidr_block      = var.master_ipv4_cidr_block
      private_endpoint_subnetwork = var.private_endpoint_subnetwork
    }] : []

    content {
      enable_private_endpoint     = private_cluster_config.value.enable_private_endpoint
      enable_private_nodes        = private_cluster_config.value.enable_private_nodes
      master_ipv4_cidr_block      = var.private_endpoint_subnetwork == null ? private_cluster_config.value.master_ipv4_cidr_block : null
      private_endpoint_subnetwork = private_cluster_config.value.private_endpoint_subnetwork
      dynamic "master_global_access_config" {
        for_each = var.master_global_access_enabled ? [var.master_global_access_enabled] : []
        content {
          enabled = master_global_access_config.value
        }
      }
    }
  }
  
}

/******************************************
  Create Container Cluster node pools
 *****************************************/

