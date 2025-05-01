provider "google" {
  project = "slovink-hyperscaler"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}


module "vpc" {
  source                                    = "git::git@github.com:slovink/gcp-terraform-gcp-vpc.git?ref=1.0.0"
  name                                      = "app"
  environment                               = "test"
  routing_mode                              = "REGIONAL"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}

module "subnet" {
  source        = "git@github.com:slovink/terraform-gcp-subnet.git?ref=1.0.0"
  name          = "app"
  environment   = "test"
  subnet_names  = ["subnet-a"]
  gcp_region    = "asia-northeast1"
  network       = module.vpc.vpc_id
  ip_cidr_range = ["10.10.1.0/24"]
}

module "Service-account" {
  source = "git::git@github.com:slovink/terraform-gcp-Service-account.git?ref=1.0.0"

  name             = "app"
  environment      = "test"
  key_algorithm    = "KEY_ALG_RSA_2048"
  public_key_type  = "TYPE_X509_PEM_FILE"
  private_key_type = "TYPE_GOOGLE_CREDENTIALS_FILE"
  roles            = ["roles/viewer", "roles/iam.serviceAccountUser"]
}

module "gke" {
  source             = "../"
  name               = "app"
  environment        = "test"
  region             = "asia-northeast1"
  image_type         = "UBUNTU_CONTAINERD"
  location           = "asia-northeast1"
  min_master_version = "1.31.6-gke.1064001"
  network            = module.vpc.vpc_id
  subnetwork         = module.subnet.subnet_id
  service_account    = module.Service-account.account_email
  initial_node_count = 1
  min_node_count     = 1
  max_node_count     = 1
  disk_size_gb       = 20
  cluster_enabled    = true
}