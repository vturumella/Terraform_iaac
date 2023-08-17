resource "google_container_cluster" "my_cluster" {
  name     = "my-gke-cluster"
  location = "us-central1-a"
  subnetwork = var.private_subnet
  network = var.vpc_name

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}
resource "google_container_node_pool" "primary_cluster_nodes" {
  name       = "my-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.my_cluster.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # service_account = google_service_account.vturumella.email
    # oauth_scopes    = [
    #   "https://www.googleapis.com/auth/cloud-platform"
    # ]
  }
}
data "google_client_config" "default" {
}
resource "kubernetes_replication_controller" "my_controlle" {
  metadata {
    name = "replication"
    labels = {
      test = "MyExampleApp"
    }
  }

  spec {
    selector = {
      test = "MyExampleApp"
    }
    template {
      metadata {
        labels = {
          test = "MyExampleApp"
        }
        annotations = {
          "key1" = "value1"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "example"

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "my_cluster_service" {
  metadata {
    name = "cluster-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.test.spec.0.template.0.metadata[0].labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 80
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_ingress_v1" "gke_ingress" {
  metadata {
    name = "gke-ingress"
  }

  spec {
    default_backend {
      service {
        name = "cluster-service"
        port {
          number = 8080
        }
      }
    }

    rule {
      http {
        path {
          backend {
            service {
              name = "cluster-service"
              port {
                number = 8080
              }
            }
          }

          path = "/cluster-service/*"
        }
      }
    }

    tls {
      secret_name = "tls-secret"
    }
  }
}
resource "kubernetes_namespace" "test" {
  metadata {
    name = "nginx"
  }
  timeouts {
    delete = "15m"
  }
  depends_on = [ google_container_node_pool.primary_cluster_nodes]
}
resource "kubernetes_deployment" "test" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "MyTestApp"
      }
    }
    
    template {
      metadata {
        labels = {
          app = "MyTestApp"
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "nginx-container"
          port {
            container_port = 80
          }
        }
      }
    }
  }
  wait_for_rollout = true
}