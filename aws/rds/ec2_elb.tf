resource "aws_elb" "elb_test" {
  name               = "foobar-terraform-elb"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}
resource "aws_instance" "ec2_instance_test1" {
  ami                    = "ami-05e411cf591b5c9f6"
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_rds_sg.id]
  subnet_id              = aws_subnet.subnet_1.id

}
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.new_vpc.id
  
}