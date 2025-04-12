# Input Variables
# GCP Project

variable "gcp_project_id" {}

variable "gcp_region_1" {}

variable "vpc_id" {}
variable "subnet1_id" {}
variable "vm_private_cidr" {}

variable "cluster_secondary_range_name" {}
variable "services_secondary_range_name" {}

variable "deletion_protection" {}
variable "remove_default_node_pool" {}
variable "master_gke_version" {}

variable "master_cidr" {}


variable "local_name" {}

variable "enable_private_endpoint" {}
variable "enable_private_nodes" {}

variable "gke_sa_name" {}
variable "firewall_tags" {}

