output "public_ip" {
  value = aws_alb.test_alb.dns_name
}