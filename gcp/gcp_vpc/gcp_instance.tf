resource "google_compute_instance" "gcptest" {
  name         = "gcptest"
  machine_type = "e2-medium"
  zone         = var.zone

  tags = ["gcptest"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "first_inst"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP

    }
  }

}

resource "google_compute_firewall" "gcp_firewall" {
  name    = "test-firewall"
  network = google_compute_network.vpc_lb.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

