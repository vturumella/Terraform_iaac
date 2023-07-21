resource "google_compute_subnetwork" "k8s_subnet" {
  name          = "${var.name}-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.reg
  network       = google_compute_network.k8s_vpc.id

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_network" "k8s_vpc" {
  name                    = "${var.name}-vpc-network"
  auto_create_subnetworks = false
}