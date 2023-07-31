resource "google_compute_autoscaler" "project_autoscale" {
    count = var.webserver_count
    project = var.project
    name   = "project-autoscaler-${count.index}"
    zone   = "${element(var.zones,count.index)}"
    target = "${element(google_compute_instance_group_manager.project_webserver_grp.*.self_link,count.index)}"

    autoscaling_policy {
        max_replicas    = 2
        min_replicas    = 1
        cooldown_period = 60

        cpu_utilization {
        target = 0.5
        }
    }
}
resource "google_compute_instance_group_manager" "project_webserver_grp" {
    name = "webserver-igm"
    base_instance_name = "project-webserver-instance"
    zone = element(var.zones,count.index)
    count = var.webserver_count
    project = var.project

    version {
        name = "ws1"
        instance_template =    var.ws-inst_tmplt
    }
    named_port {
        
        name = "http"
        port = 80
    }
}
resource "google_compute_global_forwarding_rule" "project_default" {
    name                  = "project-forwarding-rule"
    port_range            = "80"
    project = var.project
    target                = "${google_compute_target_http_proxy.project_default.self_link}"
}
resource "google_compute_target_http_proxy" "project_default" {
    name     = "project-http-proxy"
    project = var.project
    url_map  = "${google_compute_url_map.project_default.self_link}"
}

# URL map
resource "google_compute_url_map" "project_default" {
    name            = "project-url-map"
    project = var.project
    default_service = "${google_compute_backend_service.project_backend.self_link}"
}
# backend service
resource "google_compute_backend_service" "project_backend" {
    name                  = "project-backend-service"
    project = var.project
    protocol              = "HTTP"
    port_name             = "http"
    health_checks         =["${google_compute_health_check.project_hc.self_link}"]
    backend {
        group           ="${element(google_compute_instance_group_manager.project_webserver_grp.*.instance_group,0)}"
        balancing_mode  = "RATE"
        max_rate_per_instance = 100
    }
    backend {
        group           ="${element(google_compute_instance_group_manager.project_webserver_grp.*.instance_group,1)}"
        balancing_mode  = "RATE"
        max_rate_per_instance = 100
    }
}
resource "google_compute_health_check" "project_hc" {
    name               = "project-health-check"
    project = var.project
    http2_health_check {
      port = 80
      request_path = "/"
    } 
}
