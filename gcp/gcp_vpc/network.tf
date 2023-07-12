resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "subnet" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  /* secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  } */
}

resource "google_compute_network" "vpc_network1" {
  name                    = "vpc-network1"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "subnet1" {
  name          = "test-subnetwork1"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network1.id
  /* secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  } */
}

output "vpc" {
  value = [google_compute_network.vpc_network]  
}
output "vpc1" {
  value = google_compute_network.vpc_network1
    
}

