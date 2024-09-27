provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}


module "vpc" {
  source = "git::git@github.com:slovink/gcp-terraform-gcp-vpc.git"

  name                           = "vpc"
  environment                    = var.environment
  label_order                    = var.label_order
  google_compute_network_enabled = true
  enable_ula_internal_ipv6       = true
  internal_ipv6_range            = "fd20:222:dd14:0:0:0:0:0/48"
}



module "subnet" {
  source = "git@github.com:slovink/terraform-gcp-subnet.git"

  name        = "subnet"
  environment = var.environment
  label_order = var.label_order

  google_compute_subnetwork_enabled = true
  google_compute_firewall_enabled   = true
  google_compute_router_nat_enabled = true
  module_enabled                    = true
  # ipv6_access_type                   = "EXTERNAL"
  network                            = module.vpc.vpc_id
  project_id                         = ""
  private_ip_google_access           = true
  allow                              = [{ "protocol" : "tcp", "ports" : ["1-65535"] }]
  source_ranges                      = ["10.10.0.0/16"]
  asn                                = 64514
  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  filter                             = "ERRORS_ONLY"
  dest_range                         = "0.0.0.0/0"
  next_hop_gateway                   = "default-internet-gateway"
  priority                           = 1000
  secondary_ip_ranges                = [{ "range_name" : "services", "ip_cidr_range" : "10.1.0.0/16" }, { "range_name" : "pods", "ip_cidr_range" : "10.3.0.0/16" }]
}


module "Service-account" {
  source = "git::git@github.com:slovink/terraform-gcp-Service-account.git"


  name        = "Service-account"
  environment = var.environment
  label_order = var.label_order

  service_account_enabled = true
}

module "gke" {
  source                             = "../"
  name                               = "app"
  environment                        = "test"
  machine_type                       = "e2-medium"
  image_type                         = "UBUNTU_CONTAINERD"
  location                           = "asia-northeast1-a"
  min_master_version                 = "1.31.0-gke.1506000"
  remove_default_node_pool           = false
  google_container_node_pool_enabled = true
  network                            = module.vpc.vpc_id
  subnetwork                         = module.subnet.subnet_id
  initial_node_count                 = 1
  min_node_count                     = 1
  max_node_count                     = 5
  disk_size_gb                       = 20
  cluster_enabled                    = true
  enable_private_nodes               = true
}
