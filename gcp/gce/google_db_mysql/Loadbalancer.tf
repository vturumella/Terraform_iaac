resource "google_compute_autoscaler" "db_auto" {
  name   = "my-autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.foobar.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}
resource "google_compute_instance_template" "gcp_ins_tmplt" {
  name           = "my-instance-template"
  machine_type   = "e2-medium"
  can_ip_forward = false

  /* tags = ["fooE","bar"] */

  disk {
    source_image = data.google_compute_image.debian_9.id
  }

  network_interface {
    network = "default"
  }

  metadata = {
    foo = "bar"
  }
}

resource "google_compute_target_pool" "target" {
  name = "my-target-pool"
}

resource "google_compute_instance_group_manager" "foobar" {
  name = "my-igm"
  zone = var.zone

  version{
    instance_template  = google_compute_instance_template.gcp_ins_tmplt.id
    name               = "primary"
  }

  target_pools       = [google_compute_target_pool.target.id]
  base_instance_name = "gcp-instance"
}

data "google_compute_image" "debian_9" {
  family  = "debian-11"
  project = "debian-cloud"
}