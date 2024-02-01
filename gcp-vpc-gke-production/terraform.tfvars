project_id      = "terraform-project-22337777"
region          = "us-central1"
gcp_zone        = "us-central1-f"
region_us_west1 = "us-west1"


network_name                 = "k8s-vpc"
region_us_west1_sub_cidr1    = "192.168.0.0/20"
region_us_central1_sub_cidr1 = "192.168.16.0/20"
region_us_central1_sub_cidr2 = "192.168.32.0/20"


cluster_name = "private-cluster1"


image_ubuntu = "ubuntu-2204-jammy-v20240119a"
image_centos = "centos-stream-8-v20240110"
machine_type = "e2-medium"
