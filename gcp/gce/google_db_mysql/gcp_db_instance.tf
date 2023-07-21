resource "google_sql_database" "mysqldb" {
  name     = "my-database"
  instance = google_sql_database_instance.db_instance.name
}

resource "google_sql_database_instance" "db_instance" {
  name             = "my-database-instance"
  region           = var.region
  database_version = "MYSQL_8_0"
  deletion_protection=false
  settings {
    tier = "db-f1-micro"
  }
}

