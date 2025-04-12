
resource "google_compute_firewall" "fw_ssh_allow" {
  project     = var.gcp_project_id
  name        = "${var.local_name}-fw-ssh-allow"
  network     = var.vpc_id
  description = "Creates firewall rule targeting SSH instances"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [var.source_ip_ranges]
  target_tags   = ["ssh-allow"]
  priority      = 1000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}



resource "google_compute_firewall" "fw_http_allow" {
  project     = var.gcp_project_id
  name        = "${var.local_name}-fw-http-allow"
  network     = var.vpc_id
  description = "Creates firewall rule targeting HTTP instances"
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "9090"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-allow"]
  priority      = 1200

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "fw_internal_allow" {
  project     = var.gcp_project_id
  name        = "${var.local_name}-fw-internal-allow"
  network     = var.vpc_id
  description = "Creates firewall rule targeting Internal instances"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]

  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  source_ranges = [
    "${var.subnet1_cidr_range}",
    "${var.subnet2_cidr_range}"

  ]

  priority = 1300

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "fw_iap_allow" {
  project     = var.gcp_project_id
  name        = "${var.local_name}-fw-iap-allow"
  network     = var.vpc_id
  description = "Creates firewall rule targeting IAP instances"

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-allow"]
  priority      = 1400

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "fw_hc_allow" {
  name        = "${var.local_name}-fw-hc-allow"
  network     = var.vpc_id
  description = "Creates firewall rule targeting Health Check"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }
  source_ranges = [
  "${var.proxy_cidr_range}"]
  priority = 1500

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}


