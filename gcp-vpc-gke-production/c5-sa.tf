module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.0"

  project_id    = var.project_id
  prefix        = var.prefix
  names         = ["sa-gke"]
  generate_keys = false
  display_name  = "Service Account GKE"
  description   = "Using This SA for GKE"

  project_roles = [
    "${var.project_id}=>roles/container.admin",
    "${var.project_id}=>roles/iam.serviceAccountUser",
    "${var.project_id}=>roles/artifactregistry.repoAdmin",
  ]
}