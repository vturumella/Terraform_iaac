resource "google_container_cluster" "k8s_primary" {
  name     = "my-gke-cluster"
  location = var.loc
  

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.k8s_vpc.self_link
  subnetwork               = google_compute_subnetwork.k8s_subnet.self_link
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  # networking_mode          = "VPC_NATIVE"
}

resource "google_container_node_pool" "k8s_primary_nodes" {
  name       = "${var.name}-node-pool"
  location   = var.loc
  cluster    = google_container_cluster.k8s_primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
  }
}