resource "aws_db_instance" "xcloud_mydb" {
    allocated_storage    = 10
    max_allocated_storage = 50
    db_name              = "mysqlxclouddb"
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t3.micro"
    username             = var.db_user
    password             = var.db_password
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot  = true
    deletion_protection = false
}