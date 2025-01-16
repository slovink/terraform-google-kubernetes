provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

module "vpc" {
  source  = "git@github.com:slovink/terraform-google-network.git"

  name                           = "vpc"
  environment                    = var.environment
  label_order                    = var.label_order
  enable_ula_internal_ipv6       = true
  internal_ipv6_range            = "fd20:222:dd14:0:0:0:0:0/48"
}

module "subnet" {
  source = "git@github.com:slovink/terraform-google-subnets.git"
  name   = "subnet"
  environment = var.environment
  label_order = var.label_order

  network = module.vpc.vpc_id
  private_ip_google_access = true
  asn      = 64514
  ip_cidr_range = ["10.10.0.0/16"]
  nat_ip_allocate_option = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  filter = "ERRORS_ONLY"
  dest_range = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
  priority = 1000
  secondary_ip_ranges                = [{ "range_name" : "services", "ip_cidr_range" : "10.1.0.0/16" }, { "range_name" : "pods", "ip_cidr_range" : "10.3.0.0/16" }]

}

module "Service-account" {
  source  = "git@github.com:slovink/terraform-google-service-account.git"


  name        = "Service-account"
  environment = var.environment
  label_order = var.label_order

  service_account_enabled = true
}

module "gke" {
  source = "../"

  name                               = "gke"
  environment                        = var.environment
  label_order                        = var.label_order
  network                            = module.vpc.vpc_id
  subnetwork                         = module.subnet.subnet_id
  module_enabled                     = true
  google_container_cluster_enabled   = true
  location                           = "europe-west3"
  remove_default_node_pool           = false
  gke_version                        = "1.25.6-gke.1000"
  initial_node_count                 = 1
  google_container_node_pool_enabled = true
  node_count                         = 1
  min_node_count                     = 1
  max_node_count                     = 7
  cluster_name                       = "test-gke"
  project_id                         = var.gcp_project_id
  region                             = var.gcp_region
  service_account                    = ""

}