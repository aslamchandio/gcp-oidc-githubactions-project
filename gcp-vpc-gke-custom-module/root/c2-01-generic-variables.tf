# Input Variables
# GCP Project
variable "gcp_project_id" {
  description = "Project in which GCP Resources to be created"
  type        = string
}

# GCP Region
variable "gcp_region_1" {
  description = "Region in which GCP Resources to be created"
  type        = string
}

variable "gcp_region_2" {
  description = "Region in which GCP Resources to be created"
  type        = string
}

# GCP Zone

variable "gcp_zone_1" {
  description = "Zone in which GCP Resources to be created"
  type        = string
}

variable "gcp_zone_2" {
  description = "Region in which GCP Resources to be created"
  type        = string
}

variable "project_services" {
  type        = list(string)
  description = "The list of the services that we want to enable in the GCP project"
}



# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
}

# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
}