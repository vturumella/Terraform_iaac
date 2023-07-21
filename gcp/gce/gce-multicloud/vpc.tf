resource "google_compute_subnetwork" "galaxy_subnet" {
  name          = "${var.name}-subnet"
  ip_cidr_range = "10.2.0.0/16"
  project = var.project
  region        = var.region
  network       = google_compute_network.galaxy_vpc.id

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_network" "galaxy_vpc" {

  name                    = "${var.name}-vpc"
  auto_create_subnetworks = false
}