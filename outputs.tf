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