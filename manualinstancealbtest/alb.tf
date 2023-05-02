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

resource "aws_lb" "aws_lb" {
  subnets = [ aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id ]
  security_groups = [ aws_security_group.test_sg_lb.id ]
}

resource "aws_lb_listener" "test_listener" {
  load_balancer_arn = aws_lb.aws_lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.test_tg.arn
  }

}

resource "aws_lb_target_group" "test_tg" {
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.test_vpc.id
  target_type = "ip"
}


resource "aws_lb_target_group_attachment" "test_tg_attach_1" {
  target_group_arn = aws_lb_target_group.test_tg.arn
  target_id = aws_instance.test1.private_ip
}

resource "aws_lb_target_group_attachment" "test_tg_attach_2" {
  target_group_arn = aws_lb_target_group.test_tg.arn
  target_id = aws_instance.test2.private_ip
}