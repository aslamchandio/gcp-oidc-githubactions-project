# Resource: GKE Node Pool 1
resource "google_container_node_pool" "nodepool_1" {
  project  = var.gcp_project_id
  name = "${var.local_name}-nodepool-01"
  location = var.gcp_region_1
  cluster  = var.cluster_name

  node_count = 1
  node_locations = [
    "${var.gcp_region_1}-c",
    "${var.gcp_region_1}-f"
  ]

  max_pods_per_node = 110

  autoscaling {
    min_node_count  = 1
    max_node_count  = 2
    location_policy = "BALANCED"
  }


  management {
    auto_repair  = true
    auto_upgrade = true
  }

    timeouts {
    create = "35m"
    update = "35m"
  }

  upgrade_settings {
    strategy        = "SURGE"
    max_surge       = 1
    max_unavailable = 0
  }


  node_config {
    preemptible  = false
    machine_type = var.machine_type["dev"]
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size

    labels = {
      team = "devops"
      env  = "${var.local_name}-nodepool1"
    }

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = var.gke_sa_name
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    tags = var.firewall_tags
  }
}
