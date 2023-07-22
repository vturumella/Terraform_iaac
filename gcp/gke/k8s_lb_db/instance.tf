data "google_compute_zones" "available" {
}
resource "google_compute_instance" "gke_instance" {
  name         = "${var.name}-gke-instance"
  machine_type = "e2-medium"
  count        = length(data.google_compute_zones.available.names)
  zone         = data.google_compute_zones.available.names[count.index]

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.k8s_subnet.self_link

    access_config {
      // Ephemeral public IP
    }
  }
  metadata = {
    foo = "bar"
  }
}
resource "google_sql_database" "mysql_k8s_database" {
  name     = "${var.name}-database"
  instance = google_sql_database_instance.k8s_instance.name
}

resource "google_sql_database_instance" "k8s_instance" {
  name             = "${var.name}-database-instance"
  region           = "us-central1"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
  }
  deletion_protection = "false"
}
resource "google_sql_user" "mysql_k8s_users" {
  name     = "$[var.name}-users"
  instance = google_sql_database_instance.k8s_instance.name
  # host     = "me.com"
  password = "admin"
}