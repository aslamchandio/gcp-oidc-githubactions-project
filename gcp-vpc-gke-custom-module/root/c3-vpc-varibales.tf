
variable "subnet_cidrs" {
  type        = list(string)
  description = "Subnet CIDR values"
}


variable "pod_cidrs" {
  type        = list(string)
  description = "Subnet CIDR values"
}


variable "service_cidr" {
  description = "US Central1 Region in which GCP Resources to be created"
  type        = string
}


variable "source_ip_ranges" {
  type        = string
  description = "Source IP Address"
}


