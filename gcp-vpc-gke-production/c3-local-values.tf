locals {
  subnet_01 = "${var.network_name}-subnet-01"
  subnet_02 = "${var.network_name}-subnet-02"
  subnet_03 = "${var.network_name}-subnet-03"


  custom_rules_ingress = [
    // Example of custom tcp/udp rule
    {
      name          = "${var.network_name}-ssh-allow"
      description   = "Allow all INGRESS to port SSH"
      target_tags   = ["ssh-allow"]
      source_ranges = ["39.59.11.111/32"]
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
        },
      ]
    },

    {
      name          = "${var.network_name}-rdp-allow"
      description   = "Allow all INGRESS to port RDP"
      target_tags   = ["rdp-allow"]
      source_ranges = ["39.59.11.111/32"]
      allow = [{
        protocol = "tcp"
        ports    = ["3389"]
        },
      ]
    },

    {
      name          = "${var.network_name}-http-allow"
      description   = "Allow all INGRESS to port RDP"
      target_tags   = ["http-allow"]
      source_ranges = ["0.0.0.0/0"]
      allow = [{
        protocol = "tcp"
        ports    = ["80", "443", "8080", "9090"]
        },
      ]
    },

    {
      name          = "${var.network_name}-internal-allow"
      description   = "Allow all INGRESS to  Internal Working for  Subnets"
      source_ranges = ["192.168.0.0/16"]
      allow = [{
        protocol = "tcp"
        ports    = ["6500-6566"]
        },
        {
          protocol = "udp"
          ports    = ["6500-6566"]
      }]
    },

    {
      name          = "${var.network_name}-iap-allow"
      description   = "Allow all INGRESS to  IAP for Subnets"
      source_ranges = ["35.235.240.0/20"]
      allow = [{
        protocol = "tcp"
        ports    = ["22", "3389"]
        },
      ]
    },

  ]

} 