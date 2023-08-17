resource "google_compute_subnetwork" "private_subnet" {
  name          = "subnetwork"
  project = "indigo-altar-345111"
  ip_cidr_range = cidrsubnet("10.51.0.0/16",4,1)
  region        = "us-central1"
  network       = google_compute_network.custom_vpc.name

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_network" "custom_vpc" {
  project = "indigo-altar-345111"
  name                    = "vpc"
  auto_create_subnetworks = false
}