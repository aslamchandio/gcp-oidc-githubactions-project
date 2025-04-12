output "gke_vm_private_ip" {
  value = google_compute_instance.gke_vm.network_interface[0].network_ip
}

/*
output "gke_vm_public_ip" {
  value = google_compute_instance.gke_vm.network_interface[0].access_config[0].nat_ip
}
*/



