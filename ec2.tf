resource "aws_instance" "test_instance" {
  subnet_id = aws_subnet.test_subnet.id
  instance_type = "t2.micro"
  ami = data.aws_ami.ubuntu_ami_id.id
}