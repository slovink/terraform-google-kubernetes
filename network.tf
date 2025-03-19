// This file was automatically generated from a template in ./autogen/main

data "google_compute_subnetwork" "gke_subnetwork" {

  count   = var.add_cluster_firewall_rules ? 1 : 0
  name    = var.subnetworkName
  region  = local.region
  project = var.project_id
}
