resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  project = var.project
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/healthz"
    port         = "8080"
  }
}

resource "google_compute_instance_group_manager" "webserver_igm" {
  name = "appserver-igm"

  base_instance_name = "web"
  count              = 2
  zone               = element(var.zones, count.index)
  version {
    instance_template = var.ws-instance-template
  }

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }
}

resource "google_compute_autoscaler" "autoscalr" {
  # provider = google-beta

  name   = "my-autoscaler"
  project = var.project
  count  = 2
  zone   = element(var.zones, count.index)
  target = element(google_compute_instance_group_manager.webserver_igm.*.self_link,count.index)

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 1
    cooldown_period = 60

  }
}
resource "google_compute_backend_service" "service_backend" {
  name                            = "backend-service"
  project = var.project
  enable_cdn                      = true
  timeout_sec                     = 10
  connection_draining_timeout_sec = 10

  backend {
    group                 = element(google_compute_instance_group_manager.webserver_igm.*.instance_group,0)
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
  backend {
    group                 = element(google_compute_instance_group_manager.webserver_igm.*.instance_group,1)
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
  health_checks = ["${google_compute_health_check.autohealing.self_link}"]
}
resource "google_compute_global_forwarding_rule" "forward_rule" {
  name                  = "l7-xlb-forwarding-rule"
  project               = var.project
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.self_link
  # ip_address            = google_compute_global_address.default.id
}

# http proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "l7-xlb-target-http-proxy"
  project = var.project
  url_map = google_compute_url_map.default.self_link
}

# url map
resource "google_compute_url_map" "default" {
  name            = "l7-xlb-url-map"
  project         = var.project
  default_service = google_compute_backend_service.service_backend.self_link
}