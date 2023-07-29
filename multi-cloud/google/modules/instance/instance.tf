resource "google_compute_instance_template" "project_ws_tmplt" {
    name        = "webserver-template"
    count       = var.enable_autoscaling?1:0
    project     = var.project
    region      = var.region
    machine_type         = var.machine_type
    can_ip_forward       = false

    description = "This template is used to create app server instances."
    tags = ["foo", "bar"]
    labels = {
        environment = "test"
    }
    disk {
        source_image = var.image
        auto_delete  = true
        boot         = true
    }
    network_interface {
        subnetwork =   var.subnet-self_link
            
       }
}