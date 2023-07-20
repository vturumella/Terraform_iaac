resource "aws_s3_bucket" "test_bucker_s3" {
  bucket = "test-bucket-app-store"
}
resource "aws_s3_bucket_versioning" "test_bucket_versions" {
  bucket = aws_s3_bucket.test_bucker_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_security_group" "ec2-security-sg" {
  name   = "ec2-instanc3-test"
  vpc_id = "vpc-0b9f5d2068a4c5678"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_default_vpc" "default" {

}
resource "aws_instance" "ec2_instance_dev" {
  ami = "ami-05e411cf591b5c9f6"
  /* count = 3 */
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2-security-sg.id]
  subnet_id = "subnet-03ea3b823b8f065b2" 

  tags= {
    Name="example server instance"
  }
 
}