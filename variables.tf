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

variable "google_container_cluster_enabled" {
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
  default     = false
  description = "deletes the default node pool upon cluster creation."
}

variable "initial_node_count" {
  type        = number
  default     = 4
  description = "The number of nodes to create in this cluster's default node pool."
}

variable "google_container_node_pool_enabled" {
  type        = bool
  default     = true
  description = "Flag to control the cluster_enabled creation."
}

variable "node_count" {
  type        = number
  default     = 4
  description = "The number of nodes to create in this cluster's default node pool."
}

variable "service_account" {
  type        = string
  default     = ""
  description = "The Google Cloud Platform Service Account to be used by the node VMs created by GKE Autopilot or NAP."
}

variable "project" {
  type        = string
  default     = ""
  description = "The project ID to host the cluster in"

}

variable "cluster" {
  type        = string
  default     = ""
  description = "The cluster to create the node pool for."

}

######################### Autoscaling ###########################
variable "min_node_count" {
  type    = number
  default = 1
}

variable "max_node_count" {
  type    = number
  default = 4
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
  type    = string
  default = ""
}

variable "machine_type" {
  type    = string
  default = ""
}

variable "disk_size_gb" {
  type    = number
  default = 20
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