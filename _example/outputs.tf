output "name" {
  value = module.gke.*.name
}

output "id" {
  value = module.gke.*.id
}