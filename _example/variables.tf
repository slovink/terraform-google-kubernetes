variable "environment" {
  type        = string
  default     = "account"
  description = "Environment name"
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. `name`,`application`."
}

variable "gcp_project_id" {
  type        = string
  default     = "slovink-hyperscaler"
  description = "Google Cloud project ID"
}

variable "gcp_region" {
  type        = string
  default     = "europe-west3"
  description = "Google Cloud region"
}

variable "gcp_zone" {
  type        = string
  default     = "Europe-west3-c"
  description = "Google Cloud zone"
}

#variable "gcp_credentials" {
#  type        = string
#  default     = ""
#  sensitive   = true
#  description = "Google Cloud service account credentials"
#}

#variable "ip_cidr_range" {
#  type        = string
#  default     = "10.11.0.0/16"
#  description = "(Required) The range of internal addresses that are owned by this subnetwork. Provide this property when you create the subnetwork. For example, 10.0.0.0/8 or 192.168.0.0/16. Ranges must be unique and non-overlapping within a network. Only IPv4 is supported."
#}

#variable "location" {
#  description = "The location (region or zone) of the GKE cluster."
#  default     = "europe-west3"
#  type        = string
#}

#variable "vpc_id" {
#  type    = string
#  default = ""
#}

#variable "subnet_id" {
#  type    = string
#  default = ""
#}


#variable "gke_version" {
#  description = "Kubernetes version"
#  type        = string
#  default     = "1.25.6-gke.1000"
#}

#variable "initial_node_count" {
#  description = "Number of initial nodes"
#  type        = number
#  default     = 1
#}

#variable "node_count" {
#  description = "Number of nodes in node pool"
#  type        = number
#  default     = 1
#}

#variable "cluster_name" {
#  description = "GKE cluster name"
#  type        = string
#  default     = "test-gke"
#}
