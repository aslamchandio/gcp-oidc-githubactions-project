# Enabling the remaining APIs and services
resource "google_project_service" "project_services" {
  count                      = length(var.project_services)
  project                    = var.gcp_project_id
  service                    = var.project_services[count.index]
  disable_dependent_services = true

  disable_on_destroy = false
}