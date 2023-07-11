resource "google_compute_firewall" "firnet" {
    name    = "test-firewall"
    network = google_compute_network.firnet.name
    allow {
        protocol = "tcp"
        ports    = ["80", "8080", "1000-2000"]
    }
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["firnet"] 
      
}

resource "google_compute_network" "firnet" {
    name = "mynetwork"
}