
variable "vm_machine_type_map" {
  type = map(string)
}

variable "vm_disk_size" {
  description = "VMS Tags"
  type        = number
}

variable "vm_disk_type" {
  description = "Machine Boot Type"
  type        = string
}

variable "vm_private_ip" {
  description = "Machine Boot Type"
  type        = string
}
