resource "random_id" "db_name_suffix" {
  byte_length = 4
}
resource "google_sql_database" "galaxy_mysqldb" {
  name            = "${var.name}-mysql-database"
  instance        = google_sql_database_instance.galaxy_mysqldb_instance.name
  deletion_policy = "ABANDON"
}

resource "google_sql_database_instance" "galaxy_mysqldb_instance" {
  name                = "${var.name}-${random_id.db_name_suffix.hex}"
  region              = var.region
  database_version    = "MYSQL_8_0"
  deletion_protection = "false"

  settings {
    tier = "db-f1-micro"

    ip_configuration {

      authorized_networks {
        value = "0.0.0.0/0"
        name  = "all"
      }
    }
  }

}