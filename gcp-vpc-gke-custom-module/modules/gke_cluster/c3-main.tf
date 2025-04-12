# Resource: GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  project            = var.gcp_project_id
  name = "${var.local_name}-fully-pvt-cluster"
  location           = var.gcp_region_1
  network            = var.vpc_id
  subnetwork         = var.subnet1_id
  networking_mode    = "VPC_NATIVE"
  datapath_provider  = "ADVANCED_DATAPATH" #Dataplane V2 Enable
  min_master_version = var.master_gke_version

  initial_node_count       = 1
  remove_default_node_pool = var.remove_default_node_pool
  node_locations = [
    "${var.gcp_region_1}-b"
  ]


  deletion_protection       = var.deletion_protection
  default_max_pods_per_node = 110

  node_config {
    preemptible  = true
    machine_type = "e2-small"
    disk_type    = "pd-standard"
    disk_size_gb = 20

      service_account = var.gke_sa_name
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    tags = var.firewall_tags

  }
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.

  # Private Cluster Configurations
  private_cluster_config {
    enable_private_endpoint = var.enable_private_endpoint
    enable_private_nodes    = var.enable_private_nodes
    master_ipv4_cidr_block  = var.master_cidr
    master_global_access_config {
      enabled = true
    }
  }


  # IP Address Ranges
  ip_allocation_policy {
    stack_type                    = "IPV4"
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    # Enable GCS PDD CSI Driver 
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }

    # Enable GCS Fuse CSI Driver 
    gcs_fuse_csi_driver_config {
      enabled = true
    }

    # Enable GCS FileStore CSI Driver 
    gcp_filestore_csi_driver_config {
      enabled = true
    }

  }

  # Enable Vertical Pod Autoscaling
  vertical_pod_autoscaling {
    enabled = true
  }

  # Enable the Gateway API in your cluster
  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }

  monitoring_config {

    enable_components = [
      "SYSTEM_COMPONENTS",
      "APISERVER",
      "SCHEDULER",
      "CONTROLLER_MANAGER",
      "STORAGE",
      "POD",
      "DEPLOYMENT",
      "STATEFULSET",
      "DAEMONSET",
      "HPA",
    ]

    advanced_datapath_observability_config {
      enable_metrics = true
      enable_relay   = true
    }
  }

  logging_config {

    enable_components = [
      "SYSTEM_COMPONENTS",
      "APISERVER",
      "SCHEDULER",
      "CONTROLLER_MANAGER",
      "WORKLOADS",

    ]


  }


  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.gcp_project_id}.svc.id.goog"
  }

  timeouts {
    create = "35m"
    update = "35m"
  }

  # In production, change it to true (Enable it to avoid accidental deletion)

  master_authorized_networks_config {
      cidr_blocks {
      display_name = "SecondSubnet-CIDR"
      cidr_block   = var.vm_private_cidr
    }

  }


   resource_labels = {
    team = "devops"
    env  = "${var.local_name}-gke-cluster"
  }


  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      node_config,
      ip_allocation_policy,
    ]
  }


  /*

   lifecycle {
    ignore_changes = [node_pool]
  }

  */
}


/* 
Important Notes-1: It is recommended that node pools be created and 
managed as separate resources as in this. 
This allows node pools to be added and removed without recreating the cluster. 
Node pools defined directly in the google_container_cluster resource cannot be 
removed without re-creating the cluster.

Important Note-2: 
We can't create a cluster with no node pool defined, but we want to only use
separately managed node pools. So we create the smallest possible default
node pool and immediately delete it.

Important Note-3: 
Google recommends custom service accounts that have cloud-platform scope and 
permissions granted via IAM Roles.
*/


