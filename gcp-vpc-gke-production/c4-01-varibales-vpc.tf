variable "network_name" {
  description = "The name of the VPC network being created"
}

variable "region_us_central1_sub_cidr1" {
  description = "CIDR for Us Central1 Subnet1"

}

variable "region_us_central1_sub_cidr2" {
  description = "CIDR for Us Central1 Subnet2"

}

variable "region_us_west1_sub_cidr1" {
  description = "CIDR for Us West1 Subnet1"

}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "private-cluster1"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "pod-cidr"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  default     = "service-cidr"
}


variable "prefix" {
  type        = string
  description = "Prefix applied to service account names."
  default     = ""
}

variable "compute_engine_service_account" {
  description = "Service account to associate to the nodes in the cluster"
  type        = string
  default     = "sa-gke@terraform-project-335577.iam.gserviceaccount.com"

}

