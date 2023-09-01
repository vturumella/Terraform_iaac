resource "random_id" "db_name_suffix" {
    byte_length = 4
  
}
resource "google_sql_database" "postgres_db" {
  name     = "my-database-${random_id.db_name_suffix.hex}"
  instance = google_sql_database_instance.db_instance.name
  deletion_policy = "DELETE"
}

resource "google_sql_database_instance" "db_instance" {

    name             = "my-database-instance-${random_id.db_name_suffix.hex}"
    region           = "us-central1"
    database_version = "POSTGRES_14"
    settings {
        tier = "db-f1-micro"
    }

    deletion_protection  = false
}