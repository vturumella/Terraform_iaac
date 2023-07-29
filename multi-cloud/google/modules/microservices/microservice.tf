resource "random_id" "app_name_suffix" {
  byte_length = 4
}
resource "google_compute_instance_template" "project_apps_tmplt" {
  name     = "apps-${random_id.app_name_suffix.hex}"
  project  = var.project
  region   = var.region
  
  machine_type = var.machine_type

  disk {
    source_image = var.image
    auto_delete  = true
    boot         = true
  }
  network_interface {
    subnetwork = var.subnet-self_link

  }
}