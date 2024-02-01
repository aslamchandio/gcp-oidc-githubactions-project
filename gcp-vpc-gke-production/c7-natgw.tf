
# [START cloudnat_router_nat_gce]
resource "google_compute_router" "router" {
  project = var.project_id
  name    = "${var.network_name}-natrouter"
  network = module.vpc-module.network_name
  region  = var.region
}
# [END cloudnat_router_nat_gce]

# [START cloudnat_nat_gce]
module "cloud-nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = "~> 5.0"

  project_id                         = var.project_id
  region                             = var.region
  router                             = google_compute_router.router.name
  name                               = "${var.network_name}-natgw"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  min_ports_per_vm                   = 256
  max_ports_per_vm                   = 512
}