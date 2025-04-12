resource "google_service_account" "gke_sa" {
  account_id   = var.sa_name
  display_name = "Service Account VM"
}

resource "google_project_iam_member" "member-role" {
  for_each = toset([
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/artifactregistry.repoAdmin",
    "roles/container.defaultNodeServiceAccount",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/storage.admin"

  ])
  role    = each.key
  project = var.project_id
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

