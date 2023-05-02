resource "aws_launch_template" "test_launch_template" {
  image_id      = data.aws_ami.ubuntu_ami_id.id
  instance_type = "t2.micro"
  user_data     = base64encode(file("${path.module}/script.sh"))
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [aws_security_group.test_sg.id]
  }
}

resource "aws_autoscaling_group" "test_asg" {
  launch_template {
    id = aws_launch_template.test_launch_template.id
    version = "$Latest"
  }
  health_check_type   = "ELB"
  target_group_arns   = [aws_lb_target_group.test_target_grp.arn]
  min_size            = 2
  max_size            = 2
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

resource "aws_alb" "test_alb" {
  subnets         = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  security_groups = [aws_security_group.test_sg_lb.id]
}

resource "aws_alb_listener" "test_alb_listener" {
  load_balancer_arn = aws_alb.test_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_target_grp.arn
  }
}


resource "aws_lb_target_group" "test_target_grp" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_vpc.id
}

resource "aws_lb_listener_rule" "test_listener_rule" {
  listener_arn = aws_alb_listener.test_alb_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_target_grp.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_security_group" "test_sg_lb" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "test_http_lb" {
  security_group_id = aws_security_group.test_sg_lb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "test_lb_all" {
  security_group_id = aws_security_group.test_sg_lb.id
  referenced_security_group_id = aws_security_group.test_sg.id
  from_port         = -1
  to_port           = -1
  ip_protocol       = -1
}