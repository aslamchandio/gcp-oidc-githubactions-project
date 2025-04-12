resource "google_compute_network" "vpc" {
  project                         = var.gcp_project_id
  name                            = "${var.local_name}-vpc"
  auto_create_subnetworks         = false
  mtu                             = 1460
  routing_mode                    = "REGIONAL" #"GLOBAL"
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "subnet1" {
  name                     = "${var.local_name}-${var.gcp_region_1}-subnet1"
  region                   = var.gcp_region_1
  ip_cidr_range            = var.subnet_cidrs[0]
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pod-cidr1"
    ip_cidr_range = var.pod_cidrs[0]
  }

  secondary_ip_range {
    range_name    = "pod-cidr2"
    ip_cidr_range = var.pod_cidrs[1]
  }

  secondary_ip_range {
    range_name    = "service-cidr"
    ip_cidr_range = var.service_cidr
  }

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

}

resource "google_compute_subnetwork" "subnet2" {
  name                     = "${var.local_name}-${var.gcp_region_2}-subnet2"
  region                   = var.gcp_region_2
  ip_cidr_range            = var.subnet_cidrs[1]
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}


# Resource: Regional Proxy-Only Subnet (Required for Regional Application Load Balancer)
resource "google_compute_subnetwork" "regional_proxy_subnet" {
  name          = "${var.local_name}-${var.gcp_region_1}-regional-proxy-subnet"
  region        = var.gcp_region_1
  ip_cidr_range = var.subnet_cidrs[2]
  purpose       = "REGIONAL_MANAGED_PROXY"
  network       = google_compute_network.vpc.id
  role          = "ACTIVE"
}


resource "google_compute_route" "internet_route" {
  name             = "${var.local_name}-egress-igw"
  description      = "route through IGW to access internet"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.vpc.id
  next_hop_gateway = "default-internet-gateway"
  priority         = 100
}

