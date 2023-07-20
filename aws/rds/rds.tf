resource "aws_db_instance" "ec2_rds_default" {
  depends_on             = [aws_security_group.my_rds_sg]
  allocated_storage      = 10
  db_name                = var.db_name
  engine                 = var.engine
  engine_version         = lookup(var.engine-version, var.engine)
  instance_class         = var.instance_class
  username               = "vturumella"
  password               = "Q12wer34"
  vpc_security_group_ids = ["${aws_security_group.my_rds_sg.id}"]
  db_subnet_group_name   = aws_db_subnet_group.default.id
  skip_final_snapshot    = true
}
resource "aws_db_subnet_group" "default" {

  name       = "main"
  subnet_ids = ["${aws_subnet.subnet_1.id}", "${aws_subnet.subnet_2.id}"]
  tags = {
    Name = "My DB subnet group"
  }
}
resource "aws_security_group" "my_rds_sg" {
  name        = "db_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.new_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.sgcidr_block]

  }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.sgcidr_block]

  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.sgcidr_block]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}