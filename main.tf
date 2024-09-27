module "labels" {
  source = "git::https://github.com/slovink/terraform-google-labels.git"

  name        = var.name
  environment = var.environment
  label_order = var.label_order
}
data "google_client_config" "current" {
}


resource "google_container_cluster" "primary" {
  count                    = var.cluster_enabled && var.module_enabled ? 1 : 0
  name                     = format("%s", module.labels.id)
  network                  = var.network
  subnetwork               = var.subnetwork
  location                 = var.location
  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = var.initial_node_count
  min_master_version       = var.min_master_version

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "10.0.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.1.0/24" # Example internal CIDR block
      display_name = "Internal Network"
    }

    cidr_blocks {
      cidr_block   = "10.0.2.0/24" # Another internal CIDR block if needed
      display_name = "Another Internal Network"
    }
  }

  node_config {
    preemptible  = true
    machine_type = var.machine_type
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}




resource "google_container_node_pool" "node_pool" {
  for_each = { for idx, cluster in google_container_cluster.primary : idx => cluster.id }

  name               = format("%s", module.labels.id)
  project            = data.google_client_config.current.project
  location           = var.location
  cluster            = each.value
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
    image_type      = var.image_type
    machine_type    = var.machine_type
    service_account = var.service_account
    disk_size_gb    = var.disk_size_gb
    disk_type       = var.disk_type
    preemptible     = var.preemptible
  }

  dynamic "network_config" {
    for_each = length(var.pod_range) > 0 ? [var.pod_range] : []
    content {
      pod_range            = network_config.value
      enable_private_nodes = var.enable_private_nodes
    }
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





resource "null_resource" "configure_kubectl" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${format("%s", module.labels.id)} --zone ${var.location} --project ${data.google_client_config.current.project}"
    environment = {
      KUBECONFIG = var.kubectl_config_path != "" ? var.kubectl_config_path : ""
    }
  }
  depends_on = [google_container_node_pool.node_pool]
}
