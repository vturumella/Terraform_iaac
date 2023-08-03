resource "aws_elb" "stratos-elb" {
  name = "${var.name}-elb"
  # count              = var.zone_cnt
  availability_zones = toset(var.azn)

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

  #   instances                   = [aws_instance.foo.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "stratos-terraform-elb"
  }
}
resource "aws_launch_configuration" "stratos-conf" {
  name_prefix   = "${var.name}-lc-conf"
  image_id      = var.image
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bar" {
  name                 = "${var.name}-autoscale"
  launch_configuration = aws_launch_configuration.stratos-conf.name
  force_delete         = true
  availability_zones = var.azn
  min_size             = 1
  max_size             = 2

  lifecycle {
    create_before_destroy = true
  }
}
