provider "google" {
  project = "indigo-altar-345111"
  region  = "us-central1"
  zone    = "us-east1-d"
}
provider "kubernetes" {

  # kube_config = "${file("~/.kube/config")}"
  host = "https://${google_container_cluster.my_cluster.endpoint}"
  # client_certificate     = "${file("~/certs/myCA.pem")}"
  # client_key             = "${file("~/certs/myCA.key")}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
  # client_certificate = "${base64decode(google_container_cluster.my_cluster.kube_config.0.client_certificate)}"
}
