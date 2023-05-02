resource "aws_security_group" "test_sg" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "test_http" {
  security_group_id = aws_security_group.test_sg.id
  referenced_security_group_id = aws_security_group.test_sg_lb.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "test_all_traffic" {
  security_group_id = aws_security_group.test_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  to_port           = -1
  ip_protocol       = -1
}


resource "aws_vpc_security_group_ingress_rule" "test_ssh" {
  security_group_id = aws_security_group.test_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_key_pair" "test_ssh_key" {
  public_key = file("~/.ssh/badal@aws.pub")
}

resource "aws_instance" "test1" {
  ami                         = data.aws_ami.ubuntu_ami_id.id
  instance_type               = "t2.micro"
  user_data_base64            = base64encode(file("${path.module}/script.sh"))
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.private_subnet_1.id
  private_ip                  = "10.0.1.10"
  vpc_security_group_ids      = [aws_security_group.test_sg.id]
  key_name                    = aws_key_pair.test_ssh_key.key_name
}

resource "aws_instance" "test2" {
  ami                         = data.aws_ami.ubuntu_ami_id.id
  instance_type               = "t2.micro"
  user_data_base64            = base64encode(file("${path.module}/script.sh"))
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.private_subnet_2.id
  private_ip                  = "10.0.2.10"
  vpc_security_group_ids      = [aws_security_group.test_sg.id]
  key_name                    = aws_key_pair.test_ssh_key.key_name
}