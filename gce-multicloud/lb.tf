resource "google_compute_instance_group_manager" "galaxy_mig" {
  name     = "${var.name}-mig1"
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
  zone   = var.zone
  target = google_compute_instance_group_manager.galaxy_mig.id

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
resource "google_compute_forwarding_rule" "galaxy_forwarding_rule" {
  name                  = "${var.name}-forwarding-rule"
  region                = var.region
  depends_on            = [google_compute_subnetwork.galaxy_subnet]
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.galaxy_http_proxy.id
  network               = google_compute_network.galaxy_vpc.id
  subnetwork            = google_compute_subnetwork.galaxy_subnet.id
  network_tier          = "PREMIUM"
}

# HTTP target proxy
resource "google_compute_region_target_http_proxy" "galaxy_http_proxy" {
  name    = "l7-ilb-target-http-proxy"
  region  = "europe-west1"
  url_map = google_compute_region_url_map.galaxy_url_map.id
}

# URL map
resource "google_compute_region_url_map" "galaxy_url_map" {
  name            = "4{var.name}-regional-url-map"
  region          = var.region
  default_service = google_compute_backend_service.galaxy_backend_service.id
}
