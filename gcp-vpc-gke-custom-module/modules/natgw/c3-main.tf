# Natgw for First Region
# Global Public IP Address for NatgGW
resource "google_compute_address" "natgw_pip1" {
  name   = "${var.local_name}-${var.gcp_region_1}-natgw-pip"
  region = var.gcp_region_1
}

resource "google_compute_router" "router1" {
  name    = "${var.local_name}-${var.gcp_region_1}-natgw-router"
  region  = var.gcp_region_1
  network = var.vpc_id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat1" {
  name                               = "${var.local_name}-${var.gcp_region_1}-natgw"
  router                             = google_compute_router.router1.name
  region                             = var.gcp_region_1
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.natgw_pip1.self_link]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = var.subnet1_id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  min_ports_per_vm = 512
  max_ports_per_vm = 1024

  log_config {
    enable = true
    filter = "ALL" #"ERRORS_ONLY"
  }
}

# Natgw for Second Region
# Global Public IP Address for NatgGW
resource "google_compute_address" "natgw_pip2" {
  name   = "${var.local_name}-${var.gcp_region_2}-natgw-pip"
  region = var.gcp_region_2
}

resource "google_compute_router" "router2" {
  name    = "${var.local_name}-${var.gcp_region_2}-natgw-router"
  region  = var.gcp_region_2
  network = var.vpc_id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat2" {
  name                               = "${var.local_name}-${var.gcp_region_2}-natgw"
  router                             = google_compute_router.router2.name
  region                             = var.gcp_region_2
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.natgw_pip2.self_link]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = var.subnet2_id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  min_ports_per_vm = 512
  max_ports_per_vm = 1024

  log_config {
    enable = true
    filter = "ALL" #"ERRORS_ONLY"
  }
}