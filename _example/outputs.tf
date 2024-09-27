output "cluster_name" {
  value       = module.gke[*].cluster_name
  description = "an identifier for the resource with format"
}

output "id" {
  value       = module.gke[*].id
  description = "an identifier for the resource with format"
}

output "endpoint" {
  value       = module.gke.endpoint
  description = "The IP address of this cluster's Kubernetes master."
}

output "self_link" {
  value       = module.gke.self_link
  description = "The server-defined URL for the resource."
}

output "label_fingerprint" {
  value       = module.gke.label_fingerprint
  description = "an identifier for the resource with format"
}

output "maintenance_policy" {
  value       = module.gke.maintenance_policy
  description = " Duration of the time window, automatically chosen to be smallest possible in the given scenario."
}

output "master_version" {
  value       = module.gke.master_version
  description = "The current version of the master in the cluster."
}

output "cluster_location" {
  value       = module.gke.cluster_location
  description = "Location of the GKE cluster that GitLab is deployed in."
}

output "tpu_ipv4_cidr_block" {
  value       = module.gke.tpu_ipv4_cidr_block
  description = "The IP address range of the Cloud TPUs in this cluster,"
}

output "services_ipv4_cidr" {
  value       = module.gke.services_ipv4_cidr
  description = "- The IP address range of the Kubernetes services in this cluster"
}

output "cluster_autoscaling" {
  value       = module.gke.cluster_autoscaling
  description = "Specifies the Auto Upgrade knobs for the node pool."
}

#output "node_id" {
#  value       = module.gke.node_id
#  description = " An identifier for the resource with format."
#}
#
#output "instance_group_urls" {
#  value       = module.gke.instance_group_urls
#  description = "The resource URLs of the managed instance groups associated with this node pool."
#}

output "cluster_ca_certificate" {
  value       = module.gke.cluster_ca_certificate
  description = "Base64 encoded public certificate that is the root certificate of the cluster."
}

output "client_certificate" {
  value       = module.gke.client_certificate
  description = "Base64 encoded public certificate used by clients to authenticate to the cluster endpoint."
}

output "client_key" {
  value       = module.gke.client_key
  sensitive   = true
  description = "Base64 encoded private key used by clients to authenticate to the cluster endpoint."
}