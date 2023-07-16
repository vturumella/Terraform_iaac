resource "google_compute_subnetwork" "xcloud-subnet" {
  name          = "xcloud-subnetwork"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.xcloud-vpc.id

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_network" "xcloud-vpc" {
  name                    = "xcloud-project-vpc"
  auto_create_subnetworks = false
}