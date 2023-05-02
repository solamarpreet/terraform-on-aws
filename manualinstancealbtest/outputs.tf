# output "ip_1" {
#   value = aws_instance.test1.public_ip
# }

# output "ip_2" {
#   value = aws_instance.test2.public_ip
# }

output "alb_ip" {
  value = aws_lb.aws_lb.dns_name
}