output "name" {
  value = join("", google_container_cluster.primary.*.name)
}

output "id" {
  value = join("", google_container_cluster.primary.*.id)
}

output "endpoint" {
  value = join("", google_container_cluster.primary.*.endpoint)
}

output "cluster_ca_certificate" {
  value = join("", google_container_cluster.primary.*.id)
}

output "kubeconfig" {
  value = google_container_cluster.primary.kube_master_auth[0].client_certificate_config[0].client_certificate
}