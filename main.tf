module "labels" {
  source  = "git::https://github.com/slovink/terraform-google-labels.git"

  name        = var.name
  environment = var.environment
  label_order = var.label_order
}

resource "google_container_cluster" "primary" {
  count = var.google_container_cluster_enabled && var.module_enabled ? 1 : 0

  name     = module.labels.id
  location = var.location

  network                  = var.network
  subnetwork               = var.subnetwork
  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = var.initial_node_count
  min_master_version       = var.gke_version
}

resource "google_container_node_pool" "node_pool" {
  count          = var.google_container_cluster_enabled && var.module_enabled ? 1 : 0
  name           = module.labels.id
  location       = var.location
  project        = var.project_id
  cluster        = join("", google_container_cluster.primary[*].id)
  initial_node_count = var.initial_node_count

   autoscaling {
     min_node_count  = var.min_node_count
     max_node_count  = var.max_node_count
     location_policy = var.location_policy
   }

   management {
     auto_repair  = var.auto_repair
     auto_upgrade = var.auto_upgrade
   }

  node_config {
    image_type      = "UBUNTU_CONTAINERD"
    machine_type    = "e2-medium"
    service_account = var.service_account
    disk_size_gb    = "50"
    disk_type       = "pd-standard"
    preemptible     = var.preemptible
  }

  network_config {
        enable_private_nodes = true
  }


  lifecycle {
    ignore_changes        = [initial_node_count]
    create_before_destroy = false
  }

  timeouts {
    create = var.cluster_create_timeouts
    update = var.cluster_update_timeouts
    delete = var.cluster_delete_timeouts
  }
}

