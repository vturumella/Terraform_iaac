output "ws-instance-template" {
    value = var.enable_autoscaling ? "${google_compute_instance_template.ws_inst_tmplt[0].self_link}":""
}