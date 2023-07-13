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
  /* metadata = {
    foo = "bar"
  } */
  metadata_startup_script = "echo hi > /test.txt"
}


resource "google_compute_instance_template" "gcp_templt_1" {
  name        = "appserver-template"
  description = "This template is used to create app server instances."

  tags = ["dev", "test"]

  labels = {
    environment = "dev"
  }

  instance_description = "description assigned to instances"
  machine_type         = "e2-medium"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
    // backup the disk every day
    resource_policies = [google_compute_resource_policy.daily_backup.id]
  }

  // Use an existing disk resource
  /* disk {
    // Instance Templates reference disks by name, not self link
    source      = google_compute_disk.foobar.name
    auto_delete = false
    boot        = false
  } */

  network_interface {
    network = "default"
  }

  /* metadata = 
  metadata = {
    foo = "bar"
  } */

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    scopes = ["cloud-platform"]
  }
}

data "google_compute_image" "my_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

/* resource "google_compute_disk" "gcpdisk" {
  name  = "existing-disk"
  image = data.google_compute_image.my_image.self_link
  size  = 10
  type  = "pd-ssd"
  zone  = "us-central1-a"
} */

resource "google_compute_resource_policy" "daily_backup" {
  name   = "every-day-4am"
  region = var.project
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "04:00"
      }
    }
  }
}

