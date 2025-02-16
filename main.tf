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
      master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }
  
}

/******************************************
  Create Container Cluster node pools
 *****************************************/

resource "google_container_node_pool" "node_pool" {
  depends_on = [
    google_compute_firewall.intra_egress,
  ]
  for_each = local.node_pools
  name               = format("%s", module.labels.id)
  project            = var.project_id
  location           = var.location
  cluster            = join("", google_container_cluster.primary[*].id)
  cluster_type       = local.cluster_type

  version = lookup(each.value, "auto_upgrade", local.default_auto_upgrade) ? "" : lookup(
  each.value,
  "version",
  google_container_cluster.primary.min_master_version,
  )

  initial_node_count = lookup(each.value, "autoscaling", true) ? lookup(
    each.value,
    "initial_node_count",
    lookup(each.value, "min_count", 1)
  ) : null

  max_pods_per_node = lookup(each.value, "max_pods_per_node", null)
  node_count = lookup(each.value, "autoscaling", true) ? null : lookup(each.value, "node_count", 1)

  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
    content {
      min_node_count       = contains(keys(autoscaling.value), "total_min_count") ? null : lookup(autoscaling.value, "min_count", 1)
      max_node_count       = contains(keys(autoscaling.value), "total_max_count") ? null : lookup(autoscaling.value, "max_count", 100)
      location_policy      = lookup(autoscaling.value, "location_policy", null)
      total_min_node_count = lookup(autoscaling.value, "total_min_count", null)
      total_max_node_count = lookup(autoscaling.value, "total_max_count", null)
    }
  }

  management {
    auto_repair  = lookup(each.value, "auto_repair", true)
    auto_upgrade = lookup(each.value, "auto_upgrade", local.default_auto_upgrade)
  }

  upgrade_settings {
    strategy        = lookup(each.value, "strategy", "SURGE")
    max_surge       = lookup(each.value, "strategy", "SURGE") == "SURGE" ? lookup(each.value, "max_surge", 1) : null
    max_unavailable = lookup(each.value, "strategy", "SURGE") == "SURGE" ? lookup(each.value, "max_unavailable", 0) : null

    dynamic "blue_green_settings" {
      for_each = lookup(each.value, "strategy", "SURGE") == "BLUE_GREEN" ? [1] : []
      content {
        node_pool_soak_duration = lookup(each.value, "node_pool_soak_duration", null)

        standard_rollout_policy {
          batch_soak_duration = lookup(each.value, "batch_soak_duration", null)
          batch_percentage    = lookup(each.value, "batch_percentage", null)
          batch_node_count    = lookup(each.value, "batch_node_count", null)
        }
      }
    }
  }
  node_config {
    image_type                  = lookup(each.value, "image_type", "COS_CONTAINERD")
    machine_type                = lookup(each.value, "machine_type", "e2-medium")
    min_cpu_platform            = lookup(each.value, "min_cpu_platform", "")
    local_ssd_count = lookup(each.value, "local_ssd_count", 0)
    disk_size_gb    = lookup(each.value, "disk_size_gb", 30)
    disk_type       = lookup(each.value, "disk_type", "pd-standard")
    service_account = lookup(
      each.value,
      "service_account",
      local.service_account,
    )

    preemptible = lookup(each.value, "preemptible", false)
    spot        = lookup(each.value, "spot", false)

    dynamic "kubelet_config" {
      for_each = length(setintersection(
        keys(each.value),
        ["cpu_manager_policy", "cpu_cfs_quota", "cpu_cfs_quota_period", "insecure_kubelet_readonly_port_enabled", "pod_pids_limit"]
      )) != 0 ? [1] : []

      content {
        cpu_manager_policy                     = lookup(each.value, "cpu_manager_policy", "static")
        cpu_cfs_quota                          = lookup(each.value, "cpu_cfs_quota", null)
        cpu_cfs_quota_period                   = lookup(each.value, "cpu_cfs_quota_period", null)
        insecure_kubelet_readonly_port_enabled = lookup(each.value, "insecure_kubelet_readonly_port_enabled", null) != null ? upper(tostring(each.value.insecure_kubelet_readonly_port_enabled)) : null
        pod_pids_limit                         = lookup(each.value, "pod_pids_limit", null)
      }
    }
    dynamic "taint" {
      for_each = concat(
        local.node_pools_taints["all"],
        local.node_pools_taints[each.value["name"]],
      )
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }


  lifecycle {
    ignore_changes = [initial_node_count]

  }
  timeouts {
    create = lookup(var.timeouts, "create", "45m")
    update = lookup(var.timeouts, "update", "45m")
    delete = lookup(var.timeouts, "delete", "45m")
  }

}