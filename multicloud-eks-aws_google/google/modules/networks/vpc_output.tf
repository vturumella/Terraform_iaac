output "vpc_name" {
    value = google_compute_network.custom_vpc.name 
}
output "my_subnet" {
    value = google_compute_subnetwork.my_subnet.self_link
  
  
}