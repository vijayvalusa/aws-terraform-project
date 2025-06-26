#- Application Load Balancer details
output "app_target_group_arns" {
  description = "List of ARNs for app target group"
  value       = [aws_lb_target_group.app_tg.arn]
}
output "ilb_dns" {
  description = "Returning DNS name"
  value = aws_lb.ilb.dns_name
}

output "ilb_zone_id" {
  description = "Returning Zone id"
  value = aws_lb.ilb.zone_id
}

#- Web server Load balancer details
output "web_target_group_arns" {
  description = "List of ARNs for web target group"
  value       = [aws_lb_target_group.web_tg.arn]
}

output "alb_dns" {
  description = "Returning DNS name"
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "Returning Zone id"
  value = aws_lb.alb.zone_id
}

output "acm_certificate_arn" {
  value = data.aws_acm_certificate.selected.arn
}