# resource "aws_key_pair" "test_ssh_key" {
#   public_key = file("~/.ssh/badal@aws.pub")
# }

resource "aws_security_group" "test_sg" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "test_http" {
  security_group_id            = aws_security_group.test_sg.id
  referenced_security_group_id = aws_security_group.test_sg_lb.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "test_all_traffic" {
  security_group_id = aws_security_group.test_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  to_port           = -1
  ip_protocol       = -1
}


# resource "aws_vpc_security_group_ingress_rule" "test_ssh" {
#   security_group_id = aws_security_group.test_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 22
#   to_port           = 22
#   ip_protocol       = "tcp"
# }