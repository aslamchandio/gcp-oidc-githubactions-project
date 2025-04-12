# Terraform Outputs: Linux NodePool
output "gke_nodepool_1_id" {
  description = "GKE Linux Node Pool 1 ID"
  value       = google_container_node_pool.nodepool_1.id
}
output "gke_nodepool_1_version" {
  description = "GKE Linux Node Pool 1 version"
  value       = google_container_node_pool.nodepool_1.version
}




