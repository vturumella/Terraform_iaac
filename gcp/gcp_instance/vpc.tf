resource "google_compute_network" "vpc_network" {
  project                 = var.project
  name                    = "vpc-network"
  auto_create_subnetworks = true
}
resource "google_compute_subnetwork" "gcp_subnet" {
  name          = "gcp-subnet"
  ip_cidr_range = var.cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
resource "google_compute_firewall" "vpc_firewall" {
  name    = "vpc-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }
  source_tags = ["web"]
}

output "vpc" {
  value = google_compute_network.vpc_network

}
output "subnet" {
  value = google_compute_subnetwork.gcp_subnet
}
output "firewall" {
  value = google_compute_firewall.vpc_firewall

}