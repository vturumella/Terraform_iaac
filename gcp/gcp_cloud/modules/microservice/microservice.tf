resource "google_compute_instance" "apps" {
  name         = "#{var.name} - test"
  machine_type = "e2-medium"
  for_each = toset(var.zones)
  zone = each.key

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = var.image
      labels = {
        my_label = "xcloud"
      }
    }
  }

  network_interface {
    network = var.vpc-name
    subnetwork = var.subnet-name
    }
}
