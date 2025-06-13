output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.tg.arn
}

output "alb_dns" {
  description = "Returning DNS name"
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "Returning Zone id"
  value = aws_lb.alb.zone_id
}
