output "cluster_name" {
  value       = join("", google_container_cluster.primary[*].name)
  description = "an identifier for the resource with format"
}

output "id" {
  value       = join("", google_container_cluster.primary[*].id)
  description = "an identifier for the resource with format"
}

output "self_link" {
  value       = join("", google_container_cluster.primary[*].self_link)
  description = "The server-defined URL for the resource."
}

output "label_fingerprint" {
  value       = join("", google_container_cluster.primary[*].label_fingerprint)
  description = "an identifier for the resource with format"
}

output "maintenance_policy" {
  value       = google_container_cluster.primary[*].maintenance_policy
  description = " Duration of the time window, automatically chosen to be smallest possible in the given scenario."
}

output "master_version" {
  value       = join("", google_container_cluster.primary[*].master_version)
  description = "The current version of the master in the cluster."
}

output "endpoint" {
  value       = join("", google_container_cluster.primary[*].endpoint)
  description = "The IP address of this cluster's Kubernetes master."
}

output "cluster_location" {
  value       = join("", google_container_cluster.primary[*].location)
  description = "Location of the GKE cluster that GitLab is deployed in."
}

output "tpu_ipv4_cidr_block" {
  value       = join("", google_container_cluster.primary[*].tpu_ipv4_cidr_block)
  description = "The IP address range of the Cloud TPUs in this cluster,"
}

output "services_ipv4_cidr" {
  value       = join("", google_container_cluster.primary[*].services_ipv4_cidr)
  description = " The IP address range of the Kubernetes services in this cluster"
}

output "cluster_autoscaling" {
  value       = google_container_cluster.primary[*].cluster_autoscaling
  description = "Specifies the Auto Upgrade knobs for the node pool."
}

output "node_id" {
  value       = join("", google_container_node_pool.node_pool[*].id)
  description = " An identifier for the resource with format."
}

output "instance_group_urls" {
  value       = google_container_node_pool.node_pool[*].instance_group_urls
  description = "The resource URLs of the managed instance groups associated with this node pool."
}

output "cluster_ca_certificate" {
  value       = google_container_cluster.primary[0].master_auth[0].cluster_ca_certificate
  description = "Base64 encoded public certificate that is the root certificate of the cluster."
}

output "client_certificate" {
  value       = google_container_cluster.primary[0].master_auth[0].client_certificate
  description = "Base64 encoded public certificate used by clients to authenticate to the cluster endpoint."
}

output "client_key" {
  value       = google_container_cluster.primary[0].master_auth[0].client_key
  description = "Base64 encoded private key used by clients to authenticate to the cluster endpoint."
}