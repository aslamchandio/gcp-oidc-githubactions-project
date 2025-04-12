resource "google_compute_address" "vm_internal_ip" {
  name         = "${var.local_name}-vm-internal-ip"
  description  = "Internal IP address reserved for Bastion VM"
  address_type = "INTERNAL"
  region       = var.gcp_region_2
  subnetwork   = var.subnet2_id
  address      = var.vm_private_ip # Use subnet slicer to understand better https://www.davidc.net/sites/default/subnets/subnets.html
}

resource "google_compute_instance" "gke_vm" {
  name                      = "${var.local_name}-client"
  zone                      = var.gcp_zone_2
  machine_type              = var.vm_machine_type_map["dev"]
  metadata_startup_script   = file("${path.module}/web-script.sh")
  allow_stopping_for_update = true
  tags                      = var.target_tags

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnet2_self_link
    network_ip = google_compute_address.vm_internal_ip.address
    #access_config { network_tier = "STANDARD" }
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
      size  = var.vm_disk_size
      type  = var.vm_disk_type

    }

  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.sa_vm
    scopes = ["cloud-platform"]
  }

}
