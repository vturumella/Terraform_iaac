resource "aws_rds_cluster_instance" "stratos_cluster_instances" {
  count = var.zone_cnt
  identifier         = "stratos-aurora-cluster-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.stratos-rds-cluster[0].id
  instance_class     = "db.r5.large"
  engine             = aws_rds_cluster.stratos-rds-cluster[0].engine
  engine_version     = aws_rds_cluster.stratos-rds-cluster[0].engine_version
}

resource "aws_rds_cluster" "stratos-rds-cluster" {
  cluster_identifier = "aurora-cluster-${count.index}"
  count = var.zone_cnt
  availability_zones = [data.aws_availability_zones.available.names[var.zone_cnt]]
  engine = "aurora-postgresql"
  engine_version = "15.3"
  database_name      = "postgresqldb"
  master_username    = "testpostgre"
  master_password    = "barbut8chars"
  apply_immediately = true
  skip_final_snapshot = true
  deletion_protection = false
}
