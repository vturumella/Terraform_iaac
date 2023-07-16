output "xcloud-vpc" {
    value = google_compute_network.xcloud-vpc.name
}
output "subnet-self_link" {
    value = google_compute_subnetwork.xcloud-subnet.self_link
}

