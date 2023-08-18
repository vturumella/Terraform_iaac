resource "google_compute_subnetwork" "my_subnet" {
  name          = "my-subnetwork"
  project = "indigo-altar-345111"
  ip_cidr_range = cidrsubnet("10.51.0.0/16",4,1)
  region        = "us-central1"
  network       = google_compute_network.custom_vpc.name

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_network" "custom_vpc" {
  project = "indigo-altar-345111"
  name                    = "vpc"
  auto_create_subnetworks = false
}
resource "google_compute_firewall" "my_firewall" {
  name    = "my-firewall"
  project = var.project
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}
resource "google_compute_health_check" "my_hc" {
  name               = "proxy-health-check"
  project = var.project
  check_interval_sec = 1
  timeout_sec        = 1

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_region_backend_service" "my_backend" {
  name          = "compute-backend"
  project = var.project
  region        = "us-central1"
  health_checks = [google_compute_health_check.my_hc.id]
}

resource "google_compute_forwarding_rule" "my_forwd_rule" {
  name     = "compute-forwarding-rule"
  project = var.project
  region = var.region

  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.my_backend.id
  all_ports             = true
  network               = google_compute_network.custom_vpc.name
  subnetwork            = google_compute_subnetwork.my_subnet.self_link
}

resource "google_compute_route" "my_route" {
  name         = "route-ilb"
  project = var.project
  dest_range   = "0.0.0.0/0"
  network      = google_compute_network.custom_vpc.name
  next_hop_ilb = google_compute_forwarding_rule.my_forwd_rule.id
  priority     = 2000
}
resource "google_compute_router_nat" "my_nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.my_router.name
  project = var.project
  region                             = "us-central1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
resource "google_compute_router" "my_router" {
  name    = "my-router"
  project = var.project
  network = google_compute_network.custom_vpc.name
  bgp {
    asn               = 64514
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]
    advertised_ip_ranges {
      range = "1.2.3.4"
    }
    advertised_ip_ranges {
      range = "6.7.0.0/16"
    }
  }
}