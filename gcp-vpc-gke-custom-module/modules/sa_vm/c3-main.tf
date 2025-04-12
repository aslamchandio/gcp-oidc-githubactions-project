resource "google_service_account" "vm_sa" {
  account_id   = var.sa_name
  display_name = "Service Account VM"
}

resource "google_project_iam_member" "member-role" {
  for_each = toset([
    "roles/container.admin",
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/artifactregistry.repoAdmin",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/storage.admin"

  ])
  role    = each.key
  project = var.project_id
  member  = "serviceAccount:${google_service_account.vm_sa.email}"
}

