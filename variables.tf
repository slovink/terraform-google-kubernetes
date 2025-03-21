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

variable "project_id" {
  type        = string
  default     = ""
  description = "Google Cloud project ID"
}

/******************************************
  Create Container Cluster
 *****************************************/

variable "google_container_cluster_enabled" {
  type        = bool
  default     = true
  description = "Flag to control the cluster_enabled creation."
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

variable "subnetworkName" {
  type        = string
  description = "The subnetwork to host the cluster in (required)"
  default = "kubernetes-subnet"
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  default     = "latest"
}

variable "regional" {
  type        = bool
  description = "Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!)"
  default     = false
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
variable "zones" {
  type        = list(string)
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  default     = ["us-east1-b"]
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


variable "master_ipv4_cidr_block" {
  type        = string
  default     = "172.16.0.0/28"
  description = "The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR."
}

variable "cluster_ipv4_cidr" {
  type        = string
  default     = "10.240.0.0/14"
  description = "The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR."
}

variable "additional_ip_range_pods" {
  type        = list(string)
  description = "List of _names_ of the additional secondary subnet ip ranges to use for pods"
  default     = []
}

variable "release_channel" {
  type        = string
  description = "The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`."
  default     = "REGULAR"
}

variable "enable_private_nodes" {
  type        = bool
  description = "Whether nodes have internal IP addresses only"
  default     = true
}

variable "enable_private_endpoint" {
  type        = bool
  description = "Whether the master's internal IP address is used as the cluster endpoint"
  default     = false
}

variable "cluster_create_timeouts" {
  type    = string
  default = "40m"
}

variable "cluster_update_timeouts" {
  type    = string
  default = "40m"
}

variable "cluster_delete_timeouts" {
  type    = string
  default = "40m"
}

variable "timeouts" {
  type        = map(string)
  description = "Timeout for cluster operations."
  default     = {}
  validation {
    condition     = !contains([for t in keys(var.timeouts) : contains(["create", "update", "delete"], t)], false)
    error_message = "Only create, update, delete timeouts can be specified."
  }
}

variable "kubectl_config_path" {
  description = "Path to the kubectl config file. Defaults to $HOME/.kube/config"
  type        = string
  default     = ""
}

variable "firewall_priority" {
  type        = number
  description = "Priority rule for firewall rules"
  default     = 1000
}

variable "add_cluster_firewall_rules" {
  type        = bool
  description = "Create additional firewall rules"
  default     = true
}


/******************************************
  Create Container Cluster node pool
 *****************************************/

variable "node_pools" {
  type        = list(map(any))
  description = "List of maps containing node pools"

  default = [
    {
      name = "default-node-pool"
    },
  ]
}


variable "node_metadata" {
  description = "Specifies how node metadata is exposed to the workload running on the node"
  default     = "GKE_METADATA"
  type        = string

  validation {
    condition     = contains(["GKE_METADATA", "GCE_METADATA", "UNSPECIFIED", "GKE_METADATA_SERVER", "EXPOSE"], var.node_metadata)
    error_message = "The node_metadata value must be one of GKE_METADATA, GCE_METADATA, UNSPECIFIED, GKE_METADATA_SERVER or EXPOSE."
  }
}