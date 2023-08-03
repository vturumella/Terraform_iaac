resource "random_id" "db_name_suffix" {
    byte_length = 4
}

resource "google_sql_database_instance" "project_db_instance" {
    name             = "project-instance-${random_id.db_name_suffix.hex}"
    region           = var.region
    project = var.project
    database_version = "MYSQL_8_0"
    deletion_protection = false

    settings {
        tier = "db-f1-micro"
        ip_configuration {
            authorized_networks {
              value = "0.0.0.0/0"
              name = "all"
            }
        }
        # database_flags {
        #     name  = "cloudsql.iam_authentication"
        #     value = "on"
        # }
    }
}
resource "google_sql_user" "project_users" {
    name     = "project@test.com"
    project = var.project
    instance = google_sql_database_instance.project_db_instance.name
    type     = "CLOUD_IAM_USER"
}

