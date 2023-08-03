output "ws-inst_tmplt" {
    value = var.enable_autoscaling? "${google_compute_instance_template.project_ws_tmplt[0].self_link}":""
}