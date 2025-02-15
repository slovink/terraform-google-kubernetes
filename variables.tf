/******************************************
            Global Variables
 *****************************************/

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] ."
}

variable "name" {
  type        = string
  default     = ""
  description = "Name of the resource. Provided by the client when the resource is created. "
}

variable "module_enabled" {
  type        = bool
  default     = true
  description = "Flag to control the service_account_enabled creation."
}


variable "project" {
  type        = string
  default     = ""
  description = "The project ID to host the cluster in"

}

/******************************************
  Create Container Cluster
 *****************************************/

variable "google_container_cluster_enabled" {
  type        = bool
  default     = true
  description = "Flag to control the cluster_enabled creation."
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  default     = "latest"
}

variable "regional" {
  type        = bool
  description = "Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!)"
  default     = true
}


variable "zones" {
  type        = list(string)
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  default     = []
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
  default     = 1
  description = "The number of nodes to create in this cluster's default node pool."
}

variable "google_container_node_pool_enabled" {
  type        = bool
  default     = true
  description = "Flag to control the cluster_enabled creation."
}

variable "node_count" {
  type        = number
  default     = 1
  description = "The number of nodes to create in this cluster's default node pool."
}

variable "service_account" {
  type        = string
  default     = ""
  description = "The Google Cloud Platform Service Account to be used by the node VMs created by GKE Autopilot or NAP."
}


variable "cluster_ipv4_cidr" {
  type        = string
  default     = null
  description = "The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR."
}

variable "network_policy" {
  type        = bool
  description = "Enable network policy addon"
  default     = false
}

variable "network_policy_provider" {
  type        = string
  description = "The network policy provider."
  default     = "CALICO"
}

variable "deletion_protection" {
  type        = bool
  description = "Whether or not to allow Terraform to destroy the cluster."
  default     = false
}

variable "release_channel" {
  type        = string
  description = "The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`."
  default     = "REGULAR"
}


######################### Autoscaling ###########################
variable "min_node_count" {
  type    = number
  default = 2
}

variable "max_node_count" {
  type    = number
  default = 7
}

variable "location_policy" {
  type    = string
  default = "BALANCED"
}

######################### management ###########################
variable "auto_repair" {
  type    = bool
  default = true
}

variable "auto_upgrade" {
  type    = bool
  default = true
}

######################### node_config ###########################
variable "image_type" {
  type        = string
  default     = "UBUNTU_CONTAINERD"
  description = "image type "

}

variable "machine_type" {
  type    = string
  default = ""
}

variable "disk_size_gb" {
  type    = number
  default = 50
}

variable "disk_type" {
  type    = string
  default = ""
}

variable "preemptible" {
  type    = bool
  default = false
}

######################### timeouts ###########################
variable "cluster_create_timeouts" {
  type    = string
  default = "30m"
}

variable "cluster_update_timeouts" {
  type    = string
  default = "30m"
}

variable "cluster_delete_timeouts" {
  type    = string
  default = "30m"
}

variable "kubectl_config_path" {
  description = "Path to the kubectl config file. Defaults to $HOME/.kube/config"
  type        = string
  default     = ""
}

variable "cluster_name" {
  type    = string
  default = ""
}

variable "project_id" {
  type        = string
  default     = ""
  description = "Google Cloud project ID"
}

variable "region" {
  type        = string
  default     = ""
  description = "Google Cloud region"
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
variable "gke_version" {
  type        = string
  default     = ""
  description = "The minimum version of the master. "

}

