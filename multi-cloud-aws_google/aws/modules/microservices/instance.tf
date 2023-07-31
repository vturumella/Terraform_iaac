resource "random_id" "app_name_prefix" {
    byte_length = 4
  
}
resource "aws_instance" "xcloud_appserver" {
  ami           = var.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}