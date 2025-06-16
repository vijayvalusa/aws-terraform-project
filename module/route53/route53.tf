
data "aws_route53_zone" "main" {
  name = var.domain_name
}

#creating route53 record attaching load balancer
resource "aws_route53_record" "dns_record" {
  zone_id = data.aws_route53_zone.main.zone_id 
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.zone_id
    evaluate_target_health = true
  }
}
