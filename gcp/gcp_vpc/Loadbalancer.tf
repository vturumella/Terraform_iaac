resource "google_compute_subnetwork" "subnet_lb" {
  name          = "subnet-lb"
  ip_cidr_range = var.vpc_cidr
  region        = var.region
  network       = google_compute_network.vpc_lb.id
  role          = "ACTIVE"
  purpose       = "INTERNALHTTPSLOAD_BALABCER"

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
resource "google_compute_network" "vpc_lb" {
  name                    = "vpc-lb"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "backend_subnet" {
  name          = "backend-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_lb.id
}

resource "google_compute_forwarding_rule" "default" {
  name   = "website-forwarding-rule"
  region = var.region

  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.backend.id
  all_ports             = true
  network               = google_compute_network.vpc_lb.name
  subnetwork            = google_compute_subnetwork.subnet_lb.name
}

resource "google_compute_region_backend_service" "backend" {
  name          = "website-backend"
  region        = var.region
  health_checks = [google_compute_health_check.hc.id]
}

resource "google_compute_health_check" "hc" {
  name               = "check-website-backend"
  check_interval_sec = 1
  timeout_sec        = 1

  tcp_health_check {
    port = "80"
  }
}
resource "google_compute_route" "route-ilb" {
  name         = "route-ilb"
  dest_range   = "0.0.0.0/0"
  network      = google_compute_network.vpc_lb.name
  next_hop_ilb = google_compute_forwarding_rule.default.id
  priority     = 2000
}
resource "google_compute_router" "router" {
  name    = "my-router"
  region  = var.region
  network = google_compute_network.vpc_lb.id

  bgp {
    asn = 64514
  }
}
resource "google_compute_router_interface" "rout_int" {
  name       = "interface-1"
  router     = google_compute_router.router.name
  region     = var.region
  ip_range   = "169.254.1.1/30"
  /* vpn_tunnel = "tunnel-1" */
}

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}