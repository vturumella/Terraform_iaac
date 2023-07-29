output "vpc-name" {
    value = google_compute_network.project_vpc.name
}
output "subnet-self_link" {
    value = google_compute_subnetwork.project_subnet.self_link
}