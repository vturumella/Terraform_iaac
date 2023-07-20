resource "random_id" "app_name_suffix" {
    byte_length = 4
  
}
resource "google_compute_instance" "galaxy_appserver" {
    name         = "${var.name}-${random_id.app_name_suffix.hex}"
    machine_type = "e2-medium"
    count = length(data.google_compute_zones.available.names)
    zone         = data.google_compute_zones.available.names[count.index]

    tags = ["foo", "bar"]

    boot_disk {
        initialize_params {
        image = var.image
        labels = {
            my_label = "test"
        }
        }
    }
    network_interface {
       subnetwork = google_compute_subnetwork.galaxy_subnet.self_link

        access_config {
        // Ephemeral public IP
        }
    }
    metadata = {
        foo = "bar"
    }
    metadata_startup_script = "echo hi > /test.txt"
}