resource "google_compute_subnetwork" "project_subnet" {
  name        = "test-subnet"
  ip_cidr_range = cidrsubnet(var.vpc_cidr, 8, 2)
  region        = var.region
  project       = var.project
  network       = google_compute_network.project_vpc.id
} 
resource "google_compute_network" "project_vpc" {
  name                    = "project-vpc"
  project                 = var.project
  auto_create_subnetworks = false
}
resource "google_compute_firewall" "project_firewall" {
  name    = "project-firewall"
  project = var.project
  
  network = google_compute_network.project_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}
