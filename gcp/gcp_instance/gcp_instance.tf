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

  // Local SSD disk
  /* scratch_disk {
    interface = "SCSI"
  } */

  network_interface {
    network = "default"
    
    access_config {
      // Ephemeral public IP
      
    }
  }

  /* metadata = {
    foo = "bar"
  }
  metadata_startup_script = "echo hi > /test.txt" */
}

