output "natgw_public_ip1" {
  value       = google_compute_address.natgw_pip1.address
  description = "The public IP address of the newly created Nat Gateway"
}

output "natgw_public_ip2" {
  value       = google_compute_address.natgw_pip2.address
  description = "The public IP address of the newly created Nat Gateway"
}
