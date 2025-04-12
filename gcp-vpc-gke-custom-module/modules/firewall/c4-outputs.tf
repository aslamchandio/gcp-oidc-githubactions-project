# For SSH Allow
output "name_ssh" {
  value       = google_compute_firewall.fw_ssh_allow.name
  description = "The name of the firewall rule being created"
}

output "network_name_ssh" {
  value       = google_compute_firewall.fw_ssh_allow.network
  description = "The name of the VPC network where the firewall rule will be applied"
}

output "self_link_ssh" {
  value       = google_compute_firewall.fw_ssh_allow.self_link
  description = "The URI of the firewall rule  being created"
}


# For HTTP Allow
output "name_http" {
  value       = google_compute_firewall.fw_http_allow.name
  description = "The name of the firewall rule being created"
}

output "network_name_http" {
  value       = google_compute_firewall.fw_http_allow.network
  description = "The name of the VPC network where the firewall rule will be applied"
}

output "self_link_http" {
  value       = google_compute_firewall.fw_http_allow.self_link
  description = "The URI of the firewall rule  being created"
}


# For Internal Allow
output "name_internal" {
  value       = google_compute_firewall.fw_internal_allow.name
  description = "The name of the firewall rule being created"
}

output "network_name_internal" {
  value       = google_compute_firewall.fw_internal_allow.network
  description = "The name of the VPC network where the firewall rule will be applied"
}

output "self_link_internal" {
  value       = google_compute_firewall.fw_internal_allow.self_link
  description = "The URI of the firewall rule  being created"
}

# For IAP Allow
output "name_iap" {
  value       = google_compute_firewall.fw_iap_allow.name
  description = "The name of the firewall rule being created"
}

output "network_name_iap" {
  value       = google_compute_firewall.fw_iap_allow.network
  description = "The name of the VPC network where the firewall rule will be applied"
}

output "self_link_iap" {
  value       = google_compute_firewall.fw_iap_allow.self_link
  description = "The URI of the firewall rule  being created"
}

output "target_tags_iap" {
  value       = google_compute_firewall.fw_iap_allow.target_tags
  description = "The name of the firewall rule being created"
}


