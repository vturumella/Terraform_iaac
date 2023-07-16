resource "google_compute_health_check" "health_check" {
    name = "${var.name}-healthcheck"
    project = var.project

    http_health_check {
        request_path = "/"
        port         = "8080"
    }
}
resource "google_compute_instance_group_manager" "webserver-group-manager"{
    name    = "${var.name}-instance-group-manager-${count.index}"
    project = var.project
    count = var.webserver_count

    base_instance_name = "${var.project}-webserver-instance"
    zone               = "${element(var.zones,count.index)}"

    version {
        name              = "wsl"
        instance_template = var.instance_template
    }
    named_port {
        name = "http"
        port = 8888
    }
}
resource "google_compute_autoscaler" "autoscaler" {
    name   = "${var.name}-scaler-${count.index}"
    project = var.project
    count = var.webserver_count
    zone   = "${element(var.zones,count.index)}"
    target = "${element(google_compute_instance_group_manager.webserver-group-manager.*.self_link, count.index)}"
    
    autoscaling_policy {
        max_replicas    = 2
        min_replicas    = 1
        cooldown_period = 60

    cpu_utilization {
        target = 0.5
    }
    }
}
resource "google_compute_backend_service" "backend-service" {
    project = var.project
    name                            = "${var.name} - backend-service}"
    health_checks         = [google_compute_health_check.health_check.self_link]
    port_name = "http"
    protocol = "HTTP"
    
    backend {
        group = "${element(google_compute_instance_group_manager.webserver-group-manager.*.instance_group,0)}"
        balancing_mode = "RATE"
        max_rate_per_instance = 100
    }
    backend {
        group = "${element(google_compute_instance_group_manager.webserver-group-manager.*.instance_group,1)}"
        balancing_mode = "RATE"
        max_rate_per_instance = 100
    }
}
resource "google_compute_global_forwarding_rule" "xcloud-forwarding-rule" {
  name                  = "${var.name}-forwarding-rule"
  project = var.project
  target                = google_compute_target_http_proxy.xcloud-proxy.self_link
  port_range = "80"
}

# HTTP target proxy
resource "google_compute_target_http_proxy" "xcloud-proxy" {
  name     = "${var.name}-http-proxy"
  project = var.project
  url_map = "${google_compute_url_map.xcloud_url_map.self_link}" 
}

# URL map
resource "google_compute_url_map" "xcloud_url_map" {
  name            = "$[var.name}-url-map}"
  provider        = google-beta
  
  default_service = google_compute_backend_service.backend-service.self_link
}
