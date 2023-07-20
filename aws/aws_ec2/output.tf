output "public_ip" {
    value=aws_instance.ec2_instance_dev[*].public_ip
}
output "ec2_tags" {
    value=aws_instance.ec2_instance_dev[*].tags_all.Name
}