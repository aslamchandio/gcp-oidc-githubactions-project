terraform {
  required_version = "~> 1.7.0" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx 
  required_providers {
    google = {
      source = "hashicorp/google"
      #version = "5.13.0"
      version = "~> 5.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }

  }

  backend "gcs" {
    bucket = "aslam-storage-bucket"
    prefix = "prod/gke-vp-github/"
  }
}

provider "google" {
  # Configuration options
  project = var.project_id
  region  = var.region
}
