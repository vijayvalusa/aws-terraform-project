output "alb_sg_id" {
  value = [aws_security_group.alb_sg.id]
}

output "web_sg_id" {
  value = [aws_security_group.web_sg.id]
}

output "ilb_sg_id" {
  value = [aws_security_group.ilb_sg.id]
}

output "app_sg_id" {
  value = [aws_security_group.app_sg.id]
}

output "db_sg_id" {
  value = [aws_security_group.db_sg.id]
}