data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_elb" "xcloud_elb" {
  name               = "foobar-terraform-elb"
  # subnets = [var.subnet_id,var.subnet1_id]
  subnets            = [for subnet in var.subnet_id : subnet.id]
  # count = var.azn_cnt
  # availability_zones = var.azn
  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }
  cross_zone_load_balancing = true
  tags = {
    Name = "foobar-terraform-elb"
  }
}

resource "aws_launch_configuration" "xcloud_as_conf" {
  name_prefix   = "${var.name}-lc-elb"
  image_id      = var.image_id
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "xcloud_elb_grp" {
  name                 = "${var.name}-asg-elb"
  launch_configuration = aws_launch_configuration.xcloud_as_conf.name
  availability_zones = var.azn
  min_size             = 1
  max_size             = 2

  lifecycle {
    create_before_destroy = true
  }
}

