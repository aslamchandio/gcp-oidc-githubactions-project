module "vpc-module" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "~> 9.0"
  project_id                             = var.project_id
  network_name                           = var.network_name
  delete_default_internet_gateway_routes = true

  subnets = [
    {
      subnet_name           = local.subnet_01
      subnet_ip             = var.region_us_west1_sub_cidr1
      subnet_region         = var.region_us_west1
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = local.subnet_02
      subnet_ip             = var.region_us_central1_sub_cidr1
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = local.subnet_03
      subnet_ip             = var.region_us_central1_sub_cidr2
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]

  secondary_ranges = {
    (local.subnet_03) = [
      {
        range_name    = "pod-cidr"
        ip_cidr_range = "10.244.0.0/16"
      },
      {
        range_name    = "service-cidr"
        ip_cidr_range = "10.32.0.0/16"
      },

    ]

  }

  routes = [
    {
      name              = "${var.network_name}-egress-inet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      next_hop_internet = "true"
    },

  ]

}

module "firewall-submodule" {
  source        = "terraform-google-modules/network/google//modules/firewall-rules"
  version       = "~> 9.0"
  project_id    = var.project_id
  network_name  = module.vpc-module.network_name
  ingress_rules = local.custom_rules_ingress

}

