resource "google_compute_router" "k6s_router" {
  name    = "${var.name}-router"
  region  = var.reg
  network = google_compute_network.k8s_vpc.name
}
resource "google_compute_router_nat" "k8s_nat" {
  name                               = "${var.name}-router-nat"
  router                             = google_compute_router.k6s_router.name
  region                             = var.reg
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
resource "google_compute_firewall" "k9s_firewall" {
  name    = "${var.name}-firewall"
  network = google_compute_network.k8s_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}
