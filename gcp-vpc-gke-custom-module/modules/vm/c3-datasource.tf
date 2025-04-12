# Datasource: Get information about a Google Compute Image
data "google_compute_image" "my_image" {
  #Debian
  #project = "debian-cloud"  
  #family  = "debian-12"

  # CentOs
  #project = "centos-cloud"  
  #family  = "centos-stream-9"

  # RedHat
  #project = "rhel-cloud" 
  #family  = "rhel-9"

  #Ubuntu-20.04 LTS
  #project = "ubuntu-os-cloud"
  #family  = "ubuntu-2004-lts"

  #Ubuntu-22.04 LTS
  #project = "ubuntu-os-cloud"
  #family  = "ubuntu-2204-lts"

  #Ubuntu-24.04 LTS
  project = "ubuntu-os-cloud"
  family  = "ubuntu-2404-lts-amd64"

  # Microsoft
  #project = "windows-cloud"
  #family  = "windows-2022"

  # Rocky Linux
  #project = "rocky-linux-cloud"
  #family  = "rocky-linux-8"
}

/*

# Outputs
output "vmimage_project" {
  value = data.google_compute_image.my_image.project
}

output "vmimage_family" {
  value = data.google_compute_image.my_image.family
}

output "vmimage_name" {
  value = data.google_compute_image.my_image.name
}

output "vmimage_image_id" {
  value = data.google_compute_image.my_image.image_id
}

output "vmimage_status" {
  value = data.google_compute_image.my_image.status
}

output "vmimage_id" {
  value = data.google_compute_image.my_image.id
}

output "vmimage_self_link" {
  value = data.google_compute_image.my_image.self_link
}

*/

output "vmimage_info" {
  value = {
    project   = data.google_compute_image.my_image.project
    family    = data.google_compute_image.my_image.family
    name      = data.google_compute_image.my_image.name
    image_id  = data.google_compute_image.my_image.image_id
    status    = data.google_compute_image.my_image.status
    id        = data.google_compute_image.my_image.id
    self_link = data.google_compute_image.my_image.self_link
  }
}