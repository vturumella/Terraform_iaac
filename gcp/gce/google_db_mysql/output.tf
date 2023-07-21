output "gcp_service-account" {
  value = google_service_account.gcptest
}

/* output "LoadBalancer" {
    value = google_compute_forwarding_rule.default
} 
output "subnet" {
    value = google_compute_subnetwork.subnet_lb
 
}
output "vpc" {
    value = google_compute_network.vpc_lb
}

output "instance" {
    value = google_compute_instance.instance1
    sensitive = true
  
}
output "storage" {
    value = google_storage_bucket.gcp_buckete
}
output "firewall" {
    value = google_compute_firewall.gcp_firewall
} */