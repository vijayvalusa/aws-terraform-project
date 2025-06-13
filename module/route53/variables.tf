variable "domain_name" {
  default = "demovijay.xyz"
}

variable "lb_dns_name" {
  description = "The DNS name of the load balancer"
  type        = string
}

variable "zone_id" {
  description = "Hosted zone ID for the domain"
  type        = string
}
