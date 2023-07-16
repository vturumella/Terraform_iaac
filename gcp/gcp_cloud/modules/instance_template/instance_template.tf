resource "google_compute_instance_template" "ws-instance_template" {
  name = "${var.name}-wstmplt"
  description = "This template is used to create app server instances."
  count = var.enable_autoscaling ? 1:0

  

  tags = ["foo", "bar"]

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

  // Use an existing disk resource
  disk {
    // Instance Templates reference disks by name, not self link
    source      = var.image
    auto_delete = false
    boot        = false
  }

  network_interface {
    network = var.vpc-name
    subnetwork = var.subnet-name
  }

  metadata = {
    foo = "bar"
  }


}
