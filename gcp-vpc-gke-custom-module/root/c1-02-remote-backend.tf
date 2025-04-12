terraform {
  backend "gcs" {
    bucket = "aslam-tfstate-bucket"
    prefix = "dev/fully-pvt-gke-cluster-cm-cidr"
  }
}
