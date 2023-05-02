resource "aws_launch_template" "test_launch_template" {
  image_id      = data.aws_ami.ubuntu_ami_id.id
  instance_type = "t2.micro"
  user_data     = base64encode(file("${path.module}/script.sh"))
  network_interfaces {
    delete_on_termination = true
    security_groups       = [aws_security_group.test_sg.id]
  }
}

resource "aws_autoscaling_group" "test_asg" {
  launch_template {
    id      = aws_launch_template.test_launch_template.id
    version = "$Latest"
  }
  health_check_type   = "ELB"
  target_group_arns   = [aws_lb_target_group.test_target_grp.arn]
  min_size            = 2
  max_size            = 2
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}