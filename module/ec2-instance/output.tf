output "bastion_public_ip" {
  value = aws_instance.web-server.public_ip
}
