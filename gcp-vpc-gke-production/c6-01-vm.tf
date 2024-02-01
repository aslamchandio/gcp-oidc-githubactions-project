resource "google_compute_instance" "first-vm" {
  name                      = "${var.network_name}-client"
  zone                      = var.gcp_zone
  machine_type              = var.machine_type
  metadata_startup_script   = file("${path.module}/script.sh")
  allow_stopping_for_update = true
  tags                      = ["ssh-allow"]

  network_interface {
    #network = "custom_vpc_network"
    subnetwork = module.vpc-module.subnets_names[0]
    #access_config {}
  }

  boot_disk {
    initialize_params {
      image = var.image_ubuntu
      size  = 30

    }

  }


  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "sa-gke@${var.project_id}.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

}

resource "google_compute_project_metadata" "my_ssh_key" {
  metadata = {
    ssh-keys = <<EOF
      gcp-user:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCCtqILUPP7wnV29I5lp1sWenmXLiA1G5BJMrg/RFNbo61VR3vEJRLmPWjX7UOQ0rIZRenlcDpO5SHpmKtEnbbShchbiZXB7vSMehFcH6/Ga/FzzAFc0Cm1DBQ/aeY7/2q1NFATpT5HK7z+SwIgmujXUAXMsKwRN+rFS2VJibVc/CcYM2QByNbdmlrvADUczGL+LV4uF8fsQfQOWVF0zAdoxfZeT+8sxkVf1EAmvtTtcJcHXvtS30BCXZRU6L1dTXXUHC7BluT/PLh6ctDUJ0vjBQzF/fD1tnv54DI1cxJKk3JlorCEmiA83smDixVuo1hJpGG6+X5mAooCECjaNbWWqRE44qtwTweVgNt3SWtYFubQCrcrHX4evZOECMn/ilTko+8edNK4H9AmB7QJCojrD+fgz9bMFgodiyC4ZJsGdB3IW5Sf8+f/5M7x5gtFlLoKxmiuwZxjmBrIlcXfhkJw/P+utpm+4aKF5rj//Y8rFxJnXxvskc/AcM/vHe84nBWt0qsKAl3dCo8aKM+CQmqP3W/p+rEEW8AMJ/d+4OPBCWXQxUewhflOL88ozpIlwJaL5K40zs4c4UJsHpe44AbCSsARMR5LRjQyW5VEK6cP08CeyIzhjjWBOFFN8/ZQ6U5wy+iEJg+/vYVmrL/iHmQxXmNEwJIaTPOv+DFwNLbC1Q== gcp-user
    EOF
  }
}

