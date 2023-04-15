resource "aws_instance" "test_instance" {
  subnet_id = aws_subnet.test_subnet.id
  instance_type = "t2.micro"
  ami = data.aws_ami.ubuntu_ami_id.id
  key_name = aws_key_pair.test_ssh_key.id
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.test_sg.id ]
  user_data = <<-EOF

  apt update && apt -y dist-upgrade
  apt install nginx
  
  EOF
}

resource "aws_key_pair" "test_ssh_key" {
  public_key = file("~/.ssh/badal@aws.pub")
}