resource "google_compute_subnetwork" "my_subnet" {
  name          = "my-subnetwork"
  ip_cidr_range = cidrsubnet("10.51.0.0/16",4,2)
  region        = "us-central1"
  network       = google_compute_network.my_vpc.id

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
resource "google_compute_network" "my_vpc" {
  name = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "my_firewall" {
  name    = "my-firewall"
  network = google_compute_network.my_vpc.name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

resource "google_compute_router" "my_router" {
  name    = "my-router"
  # region  = google_compute_subnetwork.my_subnet.region
  network = google_compute_network.my_vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "my_nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.my_router.name
  region                             = google_compute_router.my_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
