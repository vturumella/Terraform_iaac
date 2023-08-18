output "host" {
  value = google_container_cluster.my_cluster.endpoint
}
output "token" {
  value = "data.google_client_config.default.access_token"

}
output "cluster_ca_certificate" {
  value = "base64decode(google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)"
}