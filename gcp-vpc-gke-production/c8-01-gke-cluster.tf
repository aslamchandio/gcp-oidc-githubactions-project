locals {
  cluster_type = "simple-regional-private"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}


module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "~> 29.0"

  project_id                 = var.project_id
  name                       = var.cluster_name
  regional                   = true
  region                     = var.region
  network                    = module.vpc-module.network_name
  subnetwork                 = module.vpc-module.subnets_names[1]
  ip_range_pods              = var.ip_range_pods_name
  ip_range_services          = var.ip_range_services_name
  create_service_account     = false
  service_account            = var.compute_engine_service_account
  kubernetes_version         = "1.27.8-gke.1067000"
  release_channel            = "REGULAR"
  enable_private_endpoint    = false
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "172.16.1.0/28"
  horizontal_pod_autoscaling = true
  default_max_pods_per_node  = 110
  filestore_csi_driver       = true
  remove_default_node_pool   = true
  deletion_protection        = false

  node_pools = [
    {
      name              = "nodepool-01"
      node_locations    = "${var.region}-a,${var.region}-f"
      machine_type      = "e2-medium"
      autoscaling       = false
      node_count        = 1
      local_ssd_count   = 0
      disk_size_gb      = 30
      disk_type         = "pd-balanced"
      auto_repair       = true
      auto_upgrade      = true
      service_account   = var.compute_engine_service_account
      preemptible       = false
      max_pods_per_node = 110
    },
  ]

  master_authorized_networks = [
    {
      cidr_block   = "192.168.0.0/16"
      display_name = "Subnet IP Ranges"
    },
    {
      cidr_block   = "39.59.11.111/32"
      display_name = "On Prem Public IP"
    },
  ]
  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    nodepool-01 = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    nodepool-01 = {
      nodepool-01 = true
    }
  }

  node_pools_metadata = {
    all = {}

    nodepool-01 = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_tags = {
    all = []

    nodepool-01 = [
      "nodepool-01",
    ]
  }

}