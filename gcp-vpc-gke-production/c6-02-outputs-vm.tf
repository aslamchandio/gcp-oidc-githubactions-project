output "web_vm_private_ip" {
  value = google_compute_instance.first-vm.network_interface.0.network_ip
}


#output "web_vm_public_ip" {
# value       = google_compute_instance.first-vm.network_interface.0.access_config.0.nat_ip
# description = "The public IP address of the newly created instance"
#}

output "name" {
  description = "The name of the created Cloud NAT instance"
  value       = module.cloud-nat.name
}
