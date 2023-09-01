resource "google_compute_instance_template" "ws_inst_tmplt" {
  name        = "appserver-template"
  count = var.enable_autoscaling ?1:0
  description = "This template is used to create app server instances."

  tags = ["foo", "bar"]

  labels = {
    environment = "dev"
  }

  instance_description = "description assigned to instances"
  machine_type         = var.machine_type
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image      = "debian-cloud/debian-11"
    auto_delete       = true
    boot              = true
    // backup the disk every day
    # resource_policies = [google_compute_resource_policy.daily_backup.id]
  }

  // Use an existing disk resource
#   disk {
#     source      = google_compute_region_disk.foobar.self_link
#     auto_delete = false
#     boot        = false
#   }

  network_interface {
    subnetwork = var.subnet_name
  }

  metadata = {
    foo = "bar"
  }

  # service_account {
  #   # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  #   email  = google_service_account.default.email
  #   scopes = ["cloud-platform"]
  # }
}
