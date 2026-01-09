module "labels" {
  source = "git::https://github.com/slovink/terraform-google-labels.git"

  name        = var.name
  environment = var.environment
  label_order = var.label_order
}


/******************************************
  Create Container Cluster
 *****************************************/

resource "google_container_cluster" "primary" {
  count = var.google_container_cluster_enabled && var.module_enabled ? 1 : 0

  name                     = module.labels.id
  location                 = var.location
  project                  = var.project_id
  network                  = var.network
  subnetwork               = var.subnetwork
  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = "1"
  cluster_ipv4_cidr        = var.cluster_ipv4_cidr
  min_master_version       = var.release_channel == null || var.release_channel == "UNSPECIFIED" ? local.master_version : var.kubernetes_version == "latest" ? null : var.kubernetes_version

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
    enable_private_endpoint = false # Master remains public
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

  name     = each.key
  project  = var.project_id
  location = var.location
  cluster  = join("", google_container_cluster.primary[*].id)

  node_locations = lookup(each.value, "node_locations", "") != "" ? split(",", lookup(each.value, "node_locations", "")) : null


  version = lookup(each.value, "auto_upgrade", local.default_auto_upgrade) ? google_container_cluster.primary[0].min_master_version : lookup(each.value, "version", google_container_cluster.primary[0].min_master_version)

  # -------------------------------
  # CREATE TIME ONLY
  # -------------------------------
  initial_node_count = lookup(each.value, "initial_node_count", 4)

  # -------------------------------
  # ✅ MANUAL SCALING (ADD THIS)
  # -------------------------------
  node_count = lookup(each.value, "node_count", 5)

  # -------------------------------
  # ❌ AUTOSCALING DISABLED
  # -------------------------------
  dynamic "autoscaling" {
    for_each = []   # <-- autoscaling OFF
    content {}
  }

  dynamic "placement_policy" {
    for_each = length(lookup(each.value, "placement_policy", "")) > 0 ? [each.value] : []
    content {
      type = lookup(placement_policy.value, "placement_policy", null)
    }
  }

  dynamic "network_config" {
    for_each = length(lookup(each.value, "pod_range", "")) > 0 ? [each.value] : []
    content {
      pod_range            = lookup(network_config.value, "pod_range", null)
      enable_private_nodes = var.enable_private_nodes
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
  }

  node_config {
    image_type       = lookup(each.value, "image_type", "COS_CONTAINERD")
    machine_type     = lookup(each.value, "machine_type", "e2-medium")
    min_cpu_platform = lookup(each.value, "min_cpu_platform", "")
    local_ssd_count  = lookup(each.value, "local_ssd_count", 0)
    disk_size_gb     = lookup(each.value, "disk_size_gb", 30)
    disk_type        = lookup(each.value, "disk_type", "pd-standard")
    service_account  = var.service_account
    preemptible      = lookup(each.value, "preemptible", false)
    spot             = lookup(each.value, "spot", false)

    labels = {
      environment = "prod"
    }

    tags = ["kubernetes"]
  }

  # -------------------------------
  # ✅ LIFECYCLE (FIXED)
  # -------------------------------
  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }

  timeouts {
    create = lookup(var.timeouts, "create", "45m")
    update = lookup(var.timeouts, "update", "45m")
    delete = lookup(var.timeouts, "delete", "45m")
  }
}
