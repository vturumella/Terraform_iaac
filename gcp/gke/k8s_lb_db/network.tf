resource "google_compute_router" "k6s_router" {
  name    = "${var.name}-router"
  region  = var.reg
  network = google_compute_network.k8s_vpc.name
}
resource "google_compute_router_nat" "k8s_nat" {
  name                               = "${var.name}-router-nat"
  router                             = google_compute_router.k6s_router.name
  region                             = var.reg
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
resource "kubernetes_service" "k8s_service" {
  depends_on = [null_resource.nullremote]
  metadata {
    name = "terraform-k8s-service"
  }
  spec {
    selector = {
      app = kubernetes_pod.k8s_pod.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_pod" "k8s_pod" {
  depends_on = [null_resource.nullremote]
  metadata {
    name = "terraform-k8s-pod"
    labels = {
      app = "MyApp"
    }
  }

  spec {
    container {
      image = "wordpress"
      name  = "example"
    }
  }
}

