output "xcloud-template" {
    value = var.enable_autoscaling?"{google_compute_instance_template.ws-instance_template[0].self_link}":""
}