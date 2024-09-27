variable "name" {
  type        = string
  default     = "test"
  description = "Name of the resource. Provided by the client when the resource is created. "
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] ."
}

variable "managedby" {
  type        = string
  default     = "slovink"
  description = "ManagedBy, eg 'slovink'."
}

variable "repository" {
  type        = string
  default     = "https://github.com/slovink/terraform-google-kubernetes"
  description = "Terraform current module repo"
}

variable "module_enabled" {
  type        = bool
  default     = true
  description = "Flag to control the service_account_enabled creation."
}

variable "cluster_enabled" {
  type        = bool
  default     = true
  description = "Flag to control the cluster_enabled creation."
}

variable "location" {
  type        = string
  default     = ""
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location."
}

variable "remove_default_node_pool" {
  type        = bool
  default     = true
  description = "deletes the default node pool upon cluster creation."
}

variable "initial_node_count" {
  type        = number
  default     = 0
  description = "The number of nodes to create in this cluster's default node pool."
}

variable "service_account" {
  type        = string
  default     = ""
  description = "The Google Cloud Platform Service Account to be used by the node VMs created by GKE Autopilot or NAP."
}

variable "min_node_count" {
  type        = number
  default     = 1
  description = "Minimum number of nodes in the cluster."
}

variable "max_node_count" {
  type        = number
  default     = 1
  description = "Maximum number of nodes in the cluster."
}

variable "location_policy" {
  type        = string
  default     = "BALANCED"
  description = "Specifies the policy for distributing nodes across locations, with the default being BALANCED"
}

variable "auto_repair" {
  type        = bool
  default     = true
  description = "Enables or disables automatic repair of nodes in the cluster."
}

variable "auto_upgrade" {
  type        = bool
  default     = true
  description = "Enables or disables automatic upgrades of nodes in the cluster."
}

variable "image_type" {
  type        = string
  default     = ""
  description = "Type of image to use for the nodes in the cluster."
}

variable "machine_type"
{
  type        = string
  default     = ""
  description = "Specifies the machine type for the nodes in the cluster."
}

variable "disk_size_gb" {
  type        = numberresource "google_compute_address" "example_ip" {
  name        = "example-ip"
  region      = var.region
  network_tier = "STANDARD" # Change to Standard tier
}

  default     = 10
  description = " Size of the disk in gigabytes for each node in the cluster."
}

variable "disk_type" {
  type        = string
  default     = ""
  description = " Type of disk to use for the nodes in the cluster."
}

variable "preemptible" {
  type        = bool
  default     = false
  description = "Specifies whether the nodes in the cluster should be preemptible."
}

variable "cluster_create_timeouts" {
  type        = string
  default     = "30m"
  description = "Timeout for creating the cluster."
}

variable "cluster_update_timeouts" {
  type        = string
  default     = "30m"
  description = "Timeout for updating the cluster."
}

variable "cluster_delete_timeouts" {
  type        = string
  default     = "30m"
  description = "Timeout for deleting the cluster."
}

variable "kubectl_config_path" {
  description = "Path to the kubectl config file. Defaults to $HOME/.kube/config"
  type        = string
  default     = ""
}

variable "network" {
  type        = string
  default     = ""
  description = "A reference (self link) to the VPC network to host the cluster in"
}

variable "subnetwork" {
  type        = string
  default     = ""
  description = "A reference (self link) to the subnetwork to host the cluster in"
}

variable "min_master_version" {
  type        = string
  default     = ""
  description = "The minimum version of the master. "
}
resource "google_compute_address" "example_ip" {
  name        = "example-ip"
  region      = var.region
  network_tier = "STANDARD" # Change to Standard tier
}

# Pod range for network configuration
variable "pod_range" {
  description = "The range of pod IPs for the network"
  type        = string
  default     = ""  # Optional, can be left empty if no pod range is specified
}

# Enable private nodes or not
variable "enable_private_nodes" {
  description = "Whether to enable private nodes for the node pool"
  type        = bool
  default     = false
}

variable "region" {
  type = string
  default = ""
}
