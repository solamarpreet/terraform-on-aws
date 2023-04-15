resource "aws_launch_template" "test_launch_template" {
  image_id               = data.aws_ami.ubuntu_ami_id.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.test_ssh_key.id
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  user_data              = <<-EOF
#!/bin/bash
apt update && apt -y dist-upgrade
apt install -y nginx
echo "working" > /tmp/userdatacheck.txt
EOF
}

resource "aws_autoscaling_group" "test_asg" {
  launch_template {
    id = aws_launch_template.test_launch_template.id
  }
  min_size            = 1
  max_size            = 1
  vpc_zone_identifier = [aws_subnet.test_subnet.id]
}

resource "aws_alb" "test_alb" {
  subnets         = [aws_subnet.test_subnet.id]
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
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.test_vpc.id
}

resource "aws_autoscaling_attachment" "test_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.test_asg.id
  elb                    = aws_alb.test_alb.id
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
