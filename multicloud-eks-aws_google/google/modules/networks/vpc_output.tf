output "vpc_name" {
    value = google_compute_network.custom_vpc.name 
}
output "private_subnet" {
    value = google_compute_subnetwork.private_subnet.self_link
  
  
}