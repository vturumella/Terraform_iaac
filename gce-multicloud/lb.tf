data "google_compute_zones" "available" {
}
resource "google_compute_instance_group_manager" "galaxy_mig" {
  name     = "${var.name}-mig1"
  project = var.project
  count = length(data.google_compute_zones.available.names)
  zone         = data.google_compute_zones.available.names[count.index]
  version {
    instance_template = google_compute_instance_template.galaxy_ws_template.id
    name              = "primary"
  }
  base_instance_name = "vm"
  target_size        = 2
}
resource "google_compute_autoscaler" "galaxy_autoscaler" {
  name   = "${var.name}-autoscaler"
  count  = length(data.google_compute_zones.available.names)
  zone   = data.google_compute_zones.available.names[count.index]
  target = "${element(google_compute_instance_group_manager.galaxy_mig.*.self_link,count.index)}"

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}

resource "google_compute_backend_service" "galaxy_backend_service" {
  name      = "${var.name}-backend-service"
  project   = var.project
  port_name = "http"
  protocol  = "HTTP"

  backend {
    group                 = element(google_compute_instance_group_manager.galaxy_mig.*.instance_group, 0)
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
  backend {
    group                 = element(google_compute_instance_group_manager.galaxy_mig.*.instance_group, 1)
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
  health_checks = [google_compute_http_health_check.galaxy_health_check.self_link]
}

resource "google_compute_http_health_check" "galaxy_health_check" {
  name         = "${var.name}-health-check"
  project      = var.project
  request_path = "/"
  port         = 80
}
resource "google_compute_target_http_proxy" "galaxy_http_proxy" {
  name     = "${var.name}-target-http-proxy"
 
  url_map  = google_compute_url_map.galaxy_url_map.self_link
}

# URL map
resource "google_compute_url_map" "galaxy_url_map" {
  name            = "${var.name}-al-url-map"
 
  project = var.project
  default_service = "${google_compute_backend_service.galaxy_backend_service.self_link}"
}

resource "google_compute_global_forwarding_rule" "galaxy_forwarding_rule" {
  name                  = "${var.name}-forwarding-rule"
  project = var.project
  port_range            = "80"
  target                = google_compute_target_http_proxy.galaxy_http_proxy.self_link
}
