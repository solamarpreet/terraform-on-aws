resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/24"
  enable_dns_hostnames = true

  tags = {
    "env" = "dev"
  }
}

resource "aws_subnet" "test_subnet" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "test_internet_gw" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_security_group" "test_sg" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "test_http" {
  security_group_id = aws_security_group.test_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "test_ssh" {
  security_group_id = aws_security_group.test_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}