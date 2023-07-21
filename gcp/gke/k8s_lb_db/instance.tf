data "google_compute_zones" "available" {
}
resource "google_compute_instance" "gke_instance" {
  name         = "${var.name}-gke-instance"
  machine_type = "e2-medium"
  count        = length(data.google_compute_zones.available.names)
  zone         = data.google_compute_zones.available.names[count.index]

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.k8s_subnet.self_link

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }
}