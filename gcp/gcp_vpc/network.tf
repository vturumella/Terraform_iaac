resource "google_compute_firewall" "firewall" {
  name    = "test-firewall"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["firnet"]

}
resource "google_compute_network" "vpc_network" {
  project                 = var.project
  name                    = "vpc-network"
  auto_create_subnetworks = false
  /* network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL" */

}

resource "google_compute_subnetwork" "network-with-subnetss" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  /* secondary_ip_range {
        range_name    = "tf-test-secondary-range-update1"
        ip_cidr_range = "192.168.10.0/24"
    } */
}