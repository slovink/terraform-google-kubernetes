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

  private_cluster_config {
      enable_private_nodes    = true
      enable_private_endpoint = false  # Master remains public
      master_ipv4_cidr_block  = ""
  }
  
}

/******************************************
  Create Container Cluster node pools
 *****************************************/

# resource "google_container_node_pool" "node_pool" {
#   name               = format("%s", module.labels.id)
#   project            = var.project_id
#   location           = var.location
#   cluster            = join("", google_container_cluster.primary[*].id)
#   initial_node_count = var.initial_node_count

#   autoscaling {
#     min_node_count  = var.min_node_count
#     max_node_count  = var.max_node_count
#     location_policy = var.location_policy
#   }

#   management {
#     auto_repair  = var.auto_repair
#     auto_upgrade = var.auto_upgrade
#   }

#   node_config {
#     image_type      = "COS_CONTAINERD"
#     machine_type    = var.machine_type
#     service_account = var.service_account
#     disk_size_gb    = var.disk_size_gb
#     disk_type       = var.disk_type
#     preemptible     = var.preemptible
#     kubelet_config {
#       cpu_manager_policy   = "static"
#       cpu_cfs_quota        = true
#       cpu_cfs_quota_period = "100us"
#       pod_pids_limit       = 1024
# }
#   }

#   lifecycle {
#     ignore_changes = [initial_node_count]
#     #    create_before_destroy = false
#   }
#   timeouts {
#     create = var.cluster_create_timeouts
#     update = var.cluster_update_timeouts
#     delete = var.cluster_delete_timeouts
#   }
# }