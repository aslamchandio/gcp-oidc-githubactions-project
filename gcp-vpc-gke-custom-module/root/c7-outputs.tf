# VPC Module OUTPUT

output "vpc_name" {
  value       = module.vpc.vpc_name
  description = "The name of the VPC being created"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_self_link" {
  value       = module.vpc.vpc_self_link
  description = "The URI of the VPC being created"
}

## First Subnet Output

output "subnet1_name" {
  value       = module.vpc.subnet1_name
  description = "The name of the subnetwork"
}

output "subnet1_cidr" {
  value       = module.vpc.subnet1_cidr
  description = "Primary CIDR range"
}

output "subnet1_id" {
  description = "Subnet ID"
  value       = module.vpc.subnet1_id
}

output "subnet1_self_link" {
  value       = module.vpc.subnet1_self_link
  description = "Primary CIDR range"
}

output "pod_cidr1_name" {
  value       = module.vpc.pod_cidr1_name
  description = "Name of the secondary CIDR range"
}

output "pod_cidr1_range" {
  value       = module.vpc.pod_cidr1
  description = "Secondary CIDR range"
}
output "pod_cidr2_name" {
  value       = module.vpc.pod_cidr1_name
  description = "Name of the secondary CIDR range"
}

output "pod_cidr2_range" {
  value       = module.vpc.pod_cidr2
  description = "Secondary CIDR range"
}

output "service_cidr_name" {
  value       = module.vpc.service_cidr_name
  description = "Name of the secondary CIDR range"
}

output "service_cidr_range" {
  value       = module.vpc.service_cidr
  description = "Secondary CIDR range"
}

## Second Subnet Output

output "subnet2_name" {
  value       = module.vpc.subnet2_name
  description = "The name of the subnetwork"
}

output "subnet2_cidr" {
  value       = module.vpc.subnet2_cidr
  description = "Primary CIDR range"
}

output "subnet2_self_link" {
  value       = module.vpc.subnet2_self_link
  description = "Primary CIDR range"
}

output "subnet2_id" {
  description = "Subnet ID"
  value       = module.vpc.subnet2_id
}

## Regional Proxy-Only Subne Output

output "regional_proxy_subnet_name" {
  value       = module.vpc.regional_proxy_subnet_name
  description = "The name of the subnetwork"
}

output "regional_proxy_subnet_cidr" {
  value       = module.vpc.regional_proxy_subnet_cidr
  description = "Primary CIDR range"
}

output "regional_proxy_subnet_id" {
  description = "Subnet ID"
  value       = module.vpc.regional_proxy_subnet_id
}

# Firwwall Module OUTPUT

## For SSH Allow
output "name_ssh" {
  value       = module.firewall.name_ssh
  description = "The name of the firewall rule being created"
}

output "network_name_ssh" {
  value       = module.firewall.network_name_ssh
  description = "The name of the VPC network where the firewall rule will be applied"
}

output "rule_self_link_ssh" {
  value       = module.firewall.self_link_ssh
  description = "The URI of the firewall rule  being created"
}


## For HTTP Allow
output "name_http" {
  value       = module.firewall.name_http
  description = "The name of the firewall rule being created"
}

output "network_name_http" {
  value       = module.firewall.network_name_http
  description = "The name of the VPC network where the firewall rule will be applied"
}

output "self_link_http" {
  value       = module.firewall.self_link_http
  description = "The URI of the firewall rule  being created"
}


## For Internal Allow
output "name_internal" {
  value       = module.firewall.name_internal
  description = "The name of the firewall rule being created"
}

output "network_name_internal" {
  value       = module.firewall.network_name_internal
  description = "The name of the VPC network where the firewall rule will be applied"
}

output "self_link_internal" {
  value       = module.firewall.self_link_internal
  description = "The URI of the firewall rule  being created"
}

## For IAP Allow
output "name_iap" {
  value       = module.firewall.name_iap
  description = "The name of the firewall rule being created"
}

output "network_name_iap" {
  value       = module.firewall.network_name_iap
  description = "The name of the VPC network where the firewall rule will be applied"
}

output "self_link_iap" {
  value       = module.firewall.self_link_iap
  description = "The URI of the firewall rule  being created"
}

# VM Module OUTPUT

output "gke_vm_private_ip" {
  value = module.vm.gke_vm_private_ip
}

# GKE Cluster Module OUTPUT

output "gke_cluster_name" {
  description = "GKE cluster name"
  value       = module.gke_cluster.gke_cluster_name
}

output "gke_cluster_location" {
  description = "GKE Cluster location"
  value       = module.gke_cluster.gke_cluster_location
}

output "gke_cluster_endpoint" {
  description = "GKE Cluster Endpoint"
  value       = module.gke_cluster.gke_cluster_endpoint
}

output "gke_cluster_master_version" {
  description = "GKE Cluster master version"
  value       = module.gke_cluster.gke_cluster_master_version
}

# GKE Node Pool Module OUTPUT

output "gke_nodepool_1_id" {
  description = "GKE Linux Node Pool 1 ID"
  value       = module.gke_np.gke_nodepool_1_id
}
output "gke_nodepool_1_version" {
  description = "GKE Linux Node Pool 1 version"
  value       = module.gke_np.gke_nodepool_1_version
}

## NatGW Module OUTPUT

output "natgw_public_ip1" {
  value       = module.natgw.natgw_public_ip1
  description = "The public IP address of the newly created Nat Gateway"
}

output "natgw_public_ip2" {
  value       = module.natgw.natgw_public_ip2
  description = "The public IP address of the newly created Nat Gateway"
}
