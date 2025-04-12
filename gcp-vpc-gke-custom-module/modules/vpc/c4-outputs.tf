# VPC Output

output "vpc_name" {
  value       = google_compute_network.vpc.name
  description = "The name of the VPC being created"
}

output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "vpc_self_link" {
  value       = google_compute_network.vpc.self_link
  description = "The URI of the VPC being created"
}

# First Subnet Output

output "subnet1_name" {
  value       = google_compute_subnetwork.subnet1.name
  description = "The name of the subnetwork"
}

output "subnet1_cidr" {
  value       = google_compute_subnetwork.subnet1.ip_cidr_range
  description = "Primary CIDR range"
}

output "subnet1_id" {
  description = "Subnet ID"
  value       = google_compute_subnetwork.subnet1.id
}

output "subnet1_self_link" {
  value       = google_compute_subnetwork.subnet1.self_link
  description = "Primary CIDR range"
}

output "pod_cidr1_name" {
  value       = google_compute_subnetwork.subnet1.secondary_ip_range[0].range_name
  description = "Name of the secondary CIDR range"
}

output "pod_cidr1" {
  value       = google_compute_subnetwork.subnet1.secondary_ip_range[0].ip_cidr_range
  description = "Secondary CIDR range"
}
output "pod_cidr2_name" {
  value       = google_compute_subnetwork.subnet1.secondary_ip_range[1].range_name
  description = "Name of the secondary CIDR range"
}

output "pod_cidr2" {
  value       = google_compute_subnetwork.subnet1.secondary_ip_range[1].ip_cidr_range
  description = "Secondary CIDR range"
}

output "service_cidr_name" {
  value       = google_compute_subnetwork.subnet1.secondary_ip_range[2].range_name
  description = "Name of the secondary CIDR range"
}

output "service_cidr" {
  value       = google_compute_subnetwork.subnet1.secondary_ip_range[2].ip_cidr_range
  description = "Secondary CIDR range"
}

# Second Subnet Output

output "subnet2_name" {
  value       = google_compute_subnetwork.subnet2.name
  description = "The name of the subnetwork"
}

output "subnet2_cidr" {
  value       = google_compute_subnetwork.subnet2.ip_cidr_range
  description = "Primary CIDR range"
}

output "subnet2_self_link" {
  value       = google_compute_subnetwork.subnet2.self_link
  description = "Primary CIDR range"
}

output "subnet2_id" {
  description = "Subnet ID"
  value       = google_compute_subnetwork.subnet2.id
}

# Regional Proxy-Only Subne Output

output "regional_proxy_subnet_name" {
  value       = google_compute_subnetwork.regional_proxy_subnet.name
  description = "The name of the subnetwork"
}

output "regional_proxy_subnet_cidr" {
  value       = google_compute_subnetwork.regional_proxy_subnet.ip_cidr_range
  description = "Primary CIDR range"
}

output "regional_proxy_subnet_id" {
  description = "Subnet ID"
  value       = google_compute_subnetwork.regional_proxy_subnet.id
}

