output "subnet_name" {
    value = google_compute_subnetwork.my_subnet.self_link 
}
output "vpc_name" {
    value = google_compute_network.my_vpc.self_link 
}
